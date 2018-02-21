import os
import tensorflow as tf
import h5py
import numpy as np
import random

def get_svm_weights(pos_features, neg_features):
    C = tf.constant(4)
    batch_size = 10
    weights_dim = pos_features.shape[1]
    weights = tf.Variable(np.zeros(weights_dim,dtype=np.float32),name='weights')
    feature_input = tf.placeholder(tf.float32, shape = [batch_size,weights_dim])
    label_input = tf.placeholder(tf.float32, shape = [batch_size])
    #plain_loss = tf.maximum(0,tf.subtract(1, label_input*tf.matmul(weights,tf.transpose(feature_input))))
    temp = tf.matmul(tf.reshape(weights,[1,-1]),tf.transpose(feature_input))
    plain_loss = tf.maximum(np.float32(0),tf.subtract(np.float32(1), label_input*temp))
    total_loss = plain_loss + tf.matmul(tf.reshape(weights,[1,-1]),tf.reshape(weights,[-1,1]))/2
    total_loss = tf.reduce_mean(total_loss)
    optimizer=tf.train.GradientDescentOptimizer(0.0001).minimize(total_loss)

    all_features = np.concatenate((pos_features,neg_features))
    all_labels = np.concatenate((np.ones(pos_features.shape[0]), -np.ones(neg_features.shape[0])))
    with tf.Session() as sess:
        sess.run(tf.global_variables_initializer())
        for i in xrange(30000):
            index = [random.randint(0,2980) for _ in range(10)]
            _,res_loss,res_weights = sess.run([optimizer,total_loss,weights],feed_dict={feature_input:all_features[index],label_input:all_labels[index]})
            #print(res_loss.shape)
            print('%d iteration   loss:%f'%(i,res_loss))
    
    return weights




file = h5py.File('/home/scw4750/github/global_tool/2D/traditional_algorithm/optimization/feature_label.mat','r')
all_features = file['all_features'][:]
all_features = all_features.transpose()
all_index_ref = file['all_class_index'][0][:]
for index,index_ref in enumerate(all_index_ref):
    print(index)
    one_class_index = np.squeeze(file[index_ref][:])
    one_class_index = np.int32(one_class_index-1)
    pos_features = all_features[one_class_index]
    neg_index = np.setdiff1d(np.arange(0,all_features.shape[0],dtype=np.int32),one_class_index)
    neg_features = all_features[neg_index]
    weights = get_svm_weights(pos_features,neg_features)
    break
    

print('end')

