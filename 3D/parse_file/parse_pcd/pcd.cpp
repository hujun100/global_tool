#include <iostream> 
#include <string> 
#include <pcl/io/pcd_io.h> 
#include <pcl/point_types.h> 
#include <pcl/visualization/pcl_visualizer.h> 
using namespace std; 
 
int main (int argc, char** argv){ 
typedef pcl::PointXYZRGBA PointT; 
pcl::PointCloud<PointT>::Ptr cloud (new pcl::PointCloud<PointT>); 

std::string dir = "/home/scw4750/github/3D/depth2pointCloud/build/"; 
std::string filename = "17.pcd"; 

if (pcl::io::loadPCDFile<PointT> ((dir+filename), *cloud) == -1){ 
//* load the file 
PCL_ERROR ("Couldn't read PCD file \n"); 
return (-1); 
} 
printf("Loaded %d data points from PCD\n", 
cloud->width * cloud->height); 

for (size_t i = 0; i < cloud->points.size (); i+=10000) 
printf("%8.3f %8.3f %8.3f %5d %5d %5d %5d\n", 
cloud->points[i].x, 
cloud->points[i].y, 
cloud->points[i].z, 
cloud->points[i].r, 
cloud->points[i].g, 
cloud->points[i].b, 
cloud->points[i].a 
); 

pcl::visualization::PCLVisualizer viewer("Cloud viewer"); 
viewer.setCameraPosition(0,0,-3.0,0,-1,0); 
viewer.addCoordinateSystem(0.3); 

viewer.addPointCloud(cloud); 
while(!viewer.wasStopped()) 
viewer.spinOnce(100); 
return (0); 
} 
