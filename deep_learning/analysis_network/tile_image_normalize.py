def tile_images_normalize(data, c01 = False, boost_indiv = 0.0,  boost_gamma = 1.0, single_tile = False, scale_range = 1.0, neg_pos_colors = None):
    data = data.copy()
    if single_tile:
        # promote 2D image -> 3D batch (01 -> b01) or 3D image -> 4D batch (01c -> b01c OR c01 -> bc01)
        data = data[np.newaxis]
    if c01:
        # Convert bc01 -> b01c
        assert len(data.shape) == 4, 'expected bc01 data'
        data = data.transpose(0, 2, 3, 1)

    if neg_pos_colors:
        neg_clr, pos_clr = neg_pos_colors
        neg_clr = np.array(neg_clr).reshape((1,3))
        pos_clr = np.array(pos_clr).reshape((1,3))
        # Keep 0 at 0
        data /= max(data.max(), -data.min()) + 1e-10     # Map data to [-1, 1]
        
        #data += .5 * scale_range  # now in [0, scale_range]
        #assert data.min() >= 0
        #assert data.max() <= scale_range
        if len(data.shape) == 3:
            data = data.reshape(data.shape + (1,))
        assert data.shape[3] == 1, 'neg_pos_color only makes sense if color data is not provided (channels should be 1)'
        data = np.dot((data > 0) * data, pos_clr) + np.dot((data < 0) * -data, neg_clr)

    data -= data.min()
    data *= scale_range / (data.max() + 1e-10)

    # sqrt-scale (0->0, .1->.3, 1->1)
    assert boost_indiv >= 0 and boost_indiv <= 1, 'boost_indiv out of range'
    #print 'using boost_indiv:', boost_indiv
    if boost_indiv > 0:
        if len(data.shape) == 4:
            mm = (data.max(-1).max(-1).max(-1) + 1e-10) ** -boost_indiv
        else:
            mm = (data.max(-1).max(-1) + 1e-10) ** -boost_indiv
        data = (data.T * mm).T
    if boost_gamma != 1.0:
        data = data ** boost_gamma

    # Promote single-channel data to 3 channel color
    if len(data.shape) == 3:
        # b01 -> b01c
        data = np.tile(data[:,:,:,np.newaxis], 3)

    return data