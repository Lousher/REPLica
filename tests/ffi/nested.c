#include <stdlib.h>

typedef struct { float x, y; } Point;
typedef struct { int id; int count; } Info;

// 标准结构体返回写法
Info GeneratePoints(Point **outPoints, int count) {
    Point *pts = (Point *)malloc(sizeof(Point) * count);
    for (int i = 0; i < count; i++) {
        pts[i].x = i * 1.1f;
        pts[i].y = i * 2.2f;
    }
    *outPoints = pts;

    Info res = {1024, count};
    return res;
}
