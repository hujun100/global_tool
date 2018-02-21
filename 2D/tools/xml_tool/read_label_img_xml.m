function bbox = read_label_img_xml(ffp)

xml = xmlread(ffp);
xmin = xml.getElementsByTagName('object').item(0).item(9).item(1).getTextContent();
ymin = xml.getElementsByTagName('object').item(0).item(9).item(3).getTextContent();
xmax = xml.getElementsByTagName('object').item(0).item(9).item(5).getTextContent();
ymax = xml.getElementsByTagName('object').item(0).item(9).item(7).getTextContent();

xmin = str2double(char(xmin));
ymin = str2double(char(ymin));
xmax = str2double(char(xmax));
ymax = str2double(char(ymax));

bbox = [xmin ymin xmax-xmin ymax-ymin];

end
