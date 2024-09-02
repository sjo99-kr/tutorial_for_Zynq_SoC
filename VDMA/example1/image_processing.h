using namespace cv;
using namespace std;

// Function to define the region of interest
Mat regionOfInterest(Mat img, vector<Point> vertices) {
    Mat mask = Mat::zeros(img.size(), CV_8UC1);
    fillConvexPoly(mask, vertices, Scalar(255));
    Mat maskedImg;
    bitwise_and(img, mask, maskedImg);
    return maskedImg;
}

char* lane_detected_image(string imagePath){
    Mat image = imread(imagePath);
    if(image.empty(){
        cout<< "Error Occured";
    }

    // Convert Gray scale
    Mat gray;
    cvtColor(image, gray, COLOR_BGR2GRAY);
    // Apply Gaussian Blur to reduce noise
    Mat blurred;
    GaussianBlur(gray, blurred, Size(9, 9), 0);
    
    // Perform Canny edge detection
    Mat edges;
    Canny(blurred, edges, 60, 150);

    // Define the region of interest
    vector<Point> vertices = { 
        Point(0, image.rows),
        Point(image.cols, image.rows),
        Point(465, 320),
        Point(475, 320)
    };
    
    Mat roi = regionOfInterest(edges, vertices);
    // Detect lines using Hough Line Transform
    vector<Vec4i> line_mode;
    HoughLinesP(roi, line_mode, 2, CV_PI / 180, 45, 40, 100);
    int i = 0;
    // Draw the lines on the original image
    int min_x =0;
    int min_y = 0;
    int max_x = 0;
    int max_y = 0;

    Mat lineImage = image.clone();

    for (const auto& line_mode_partial : line_mode) {
        line(lineImage, Point(line_mode_partial[0], line_mode_partial[1]), Point(line_mode_partial[2], line_mode_partial[3]), Scalar(255, 255, 0), 2);
        if(i==0){
            min_x = line_mode_partial[0];
            min_y = line_mode_partial[1];
            max_x = line_mode_partial[2];
            max_y = line_mode_partial[3];
        }
        else {
            int x_min = min(line_mode_partial[0], line_mode_partial[2]);
            int x_max = max(line_mode_partial[0], line_mode_partial[2]);
            int y_min = min(line_mode_partial[1], line_mode_partial[3]);
            int y_max = max(line_mode_partial[1], line_mode_partial[3]);
            
            if(min_x > x_min){
                min_x = x_min;
            }
            if(min_y > y_min){
                min_y = y_min;
            }
            if(max_x < x_max){
                max_x = x_max;
            }
            if(max_y <y_max){
                max_y = y_max;
            }
        }
        i = i +1;
    }
    //crop 
    
    Rect crop(min_x, min_y, max_x-min_x, max_y-min_y);
    Mat cropImage = lineImage(crop);
    Mat resize_mat;
    resize(cropImage, resize_mat, Size(150,120));

    int cols = max_x - min_x;
    int rows = max_y - min_y;
    char *array[rows*cols*3];
    cout << cropImage.channels() << endl;
    std::memcpy(array, cropImage.data, 3*rows * cols * sizeof(uchar));
    return array;
}
