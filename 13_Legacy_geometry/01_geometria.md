# Geometria

## Retornar el angulo mas pequeño entre dos vectores

```cpp
const double PI = 3.14159265358979323846;

double radianesAGrados(double radianes) {
    return radianes * 180.0 / PI;
}

double gradosARadianes(double grados) {
    return grados * PI / 180.0;
}

//2D
double angleBetweenVectors(double v1x, double v1y, double v2x, double v2y) {
    // Para determinar el ángulo entre dos vectores v1 y v2, podemos usar la siguiente fórmula:
    // dot(v1, v2) = len(v1) * len(v2) * cos(θ) y resolver para θ, donde dot(a, b) es el producto escalar
    // y len(c) es la longitud de c.
    double dotproduct = (v1x * v2x) + (v1y * v2y);
    double v1Length = sqrt(v1x * v1x + v1y * v1y);
    double v2Length = sqrt(v2x * v2x + v2y * v2y);

    double value = dotproduct / (v1Length * v2Length);

    // La precisión de redondeo de un valor double puede hacer que el valor que estamos a punto de pasar a la función acos esté ligeramente fuera de su dominio, así que hacemos una comprobación de seguridad.
    if (value <= -1.0) return PI;
    if (value >= +1.0) return 0;
    return acos(value);
}
//3D
double angleBetweenVectors(
    double v1x, double v1y, double v1z,
    double v2x, double v2y, double v2z) {

    // Para determinar el ángulo entre dos vectores v1 y v2, podemos usar
    // la siguiente fórmula: dot(v1,v2) = len(v1)*len(v2)*cosθ y resolver
    // para θ donde dot(a,b) es el producto escalar y len(c) es la longitud de c.
    double dotproduct = (v1x * v2x) + (v1y * v2y) + (v1z * v2z);
    double v1Length = sqrt(v1x * v1x + v1y * v1y + v1z * v1z);
    double v2Length = sqrt(v2x * v2x + v2y * v2y + v2z * v2z);

    double value = dotproduct / (v1Length * v2Length);

    // La precisión de doble precisión puede llevar a un dominio ligeramente inválido
    // para la función arccos, así que asegúrate de comprobar las condiciones de límite.
    if (value <= -1.0) return PI;
    if (value >= +1.0) return 0;
    return acos(value);
}

int main() {

    double v1x = 1.0, v1y = 0.0, v1z = 0.0; // Ejemplo de vector 1
    double v2x = 0.0, v2y = 1.0, v2z = 0.0; // Ejemplo de vector 2
    double angle = angleBetweenVectors(1.0, 0.0, 0.0, 1.0); // Ejemplo de uso de la función
    cout << "Ángulo entre los vectores: " << angle << " radianes" << endl;
    angle = angleBetweenVectors(v1x, v1y, v1z, v2x, v2y, v2z); // Calcular el ángulo
    cout << "Ángulo entre los vectores: " << angle << " radianes" << endl;
    
    return 0;
}
```

## Area de la interseccion de dos circulos

```cpp
const double EPS = 1e-6;

struct Point {
    double x, y;
    Point() : x(0), y(0) {}
    Point(double x, double y) : x(x), y(y) {}
};

Point rotatePoint(Point fp, Point pt, double angle) {
    double fpx = fp.x;
    double fpy = fp.y;
    double ptx = pt.x;
    double pty = pt.y;
    double x = ptx - fpx;
    double y = pty - fpy;
    double xRotated = x * cos(angle) + y * sin(angle);
    double yRotated = y * cos(angle) - x * sin(angle);
    return Point(fpx + xRotated, fpy + yRotated);
}

double arccosSafe(double x) {
    if (x >= 1.0) return 0;
    if (x <= -1.0) return M_PI;
    return acos(x);
}

vector<Point> circleCircleIntersection(Point c1, double r1, Point c2, double r2) {
    double r, R;
    Point c, C;

    if (r1 < r2) r = r1,R = r2,c = c1,C = c2;
    else r = r2,R = r1,c = c2,C = c1;
    

    double dist = hypot(c1.x - c2.x, c1.y - c2.y);

    if (dist < EPS && abs(r - R) < EPS)
        return vector<Point>(); // Infinite solutions

    if (r + dist < R)
        return vector<Point>(); // No intersection (small circle contained within big circle)

    if (r + R < dist)
        return vector<Point>(); // No intersection (circles are disjoint)

    double cx = c.x;
    double Cx = C.x;
    double cy = c.y;
    double Cy = C.y;

    double vx = cx - Cx;
    double vy = cy - Cy;
    double x = (vx / dist) * R + Cx;
    double y = (vy / dist) * R + Cy;
    Point point(x, y);

    if (abs(r + R - dist) < EPS || abs(R - (r + dist)) < EPS)
        return vector<Point>{point};

    double angle = arccosSafe((r * r - dist * dist - R * R) / (-2.0 * dist * R));
    Point pt1 = rotatePoint(C, point, angle);
    Point pt2 = rotatePoint(C, point, -angle);

    return vector<Point>{pt1, pt2};
}

double circleCircleIntersectionArea(Point c1, double r1, Point c2, double r2) {
    double r = r1, R = r2;
    Point c = c1, C = c2;

    if (r1 > r2) r = r2,R = r1,c = c2,C = c1;
    

    double dist = hypot(c1.x - c2.x, c1.y - c2.y);
    vector<Point> intersections = circleCircleIntersection(c1, r1, c2, r2);

    if (intersections.empty()) {
        return M_PI * r * r; // Smaller circle is contained within larger circle
    } else if (intersections.size() == 1) {
        if (dist < R) {
            return M_PI * r * r; // Check if the smaller circle is inside the larger circle
        } else {
            return 0;
        }
    } else {
        double d = dist;
        double part1 = r * r * arccosSafe((d * d + r * r - R * R) / (2 * d * r));
        double part2 = R * R * arccosSafe((d * d + R * R - r * r) / (2 * d * R));
        double part3 = 0.5 * sqrt((-d + r + R) * (d + r - R) * (d - r + R) * (d + r + R));
        return part1 + part2 - part3;
    }
}

int main() {
    Point c1(0, 0);
    double r1 = 3.0;
    Point c2(4, 0);
    double r2 = 2.0;

    double area = circleCircleIntersectionArea(c1, r1, c2, r2);

    cout << "Area of intersection: " << area << endl;

    return 0;
}
```

## Punto de interesccion entre dos circulos

```cpp
const double EPS = 0.0000001;

// Define a Point structure
struct Point {
    double x;
    double y;

    Point(double x, double y) : x(x), y(y) {}
};

// Define a Circle structure
struct Circle {
    double x;
    double y;
    double r;

    Circle(double x, double y, double r) : x(x), y(y), r(r) {}
};

// Due to double rounding precision, the value passed into the acos function
// may be outside its domain of [-1, +1], which would return NaN. We want to avoid that.
double acossafe(double x) {
    if (x >= 1.0) return 0;
    if (x <= -1.0) return M_PI;
    return acos(x);
}

// Rotates a point about a fixed point at some angle 'a'
Point rotatePoint(Point fp, Point pt, double a) {
    double x = pt.x - fp.x;
    double y = pt.y - fp.y;
    double xRot = x * cos(a) + y * sin(a);
    double yRot = y * cos(a) - x * sin(a);
    return Point(fp.x + xRot, fp.y + yRot);
}

// Given two circles, this method finds the intersection point(s) of the two circles (if any exists)
vector<Point> circleCircleIntersectionPoints(Circle c1, Circle c2) {
    double r, R, d, dx, dy, cx, cy, Cx, Cy;

    if (c1.r < c2.r) {
        r = c1.r,R = c2.r,cx = c1.x,cy = c1.y,Cx = c2.x,Cy = c2.y;
    } else {
        r = c2.r,R = c1.r,Cx = c1.x,Cy = c1.y,cx = c2.x,cy = c2.y;
    }

    // Compute the vector <dx, dy>
    dx = cx - Cx;
    dy = cy - Cy;

    // Find the distance between two points.
    d = sqrt(dx * dx + dy * dy);

    // There are an infinite number of solutions.
    // Seems appropriate to also return an empty vector.
    if (d < EPS && abs(R - r) < EPS) return vector<Point>();

    // No intersection (circles centered at the same place with different sizes)
    else if (d < EPS) return vector<Point>();

    double x = (dx / d) * R + Cx;
    double y = (dy / d) * R + Cy;
    Point P(x, y);

    // Single intersection (kissing circles)
    if (abs((R + r) - d) < EPS || abs(R - (r + d)) < EPS) return vector<Point>{P};

    // No intersection. Either the small circle is contained within the big circle
    // or the circles are simply disjoint.
    if ((d + r) < R || (R + r < d)) return vector<Point>();

    Point C(Cx, Cy);
    double angle = acossafe((r * r - d * d - R * R) / (-2.0 * d * R));
    Point pt1 = rotatePoint(C, P, +angle);
    Point pt2 = rotatePoint(C, P, -angle);
    return vector<Point>{pt1, pt2};
}

int main() {
    Circle c1(0, 0, 1);
    Circle c2(2, 0, 1);
    
    vector<Point> intersectionPoints = circleCircleIntersectionPoints(c1, c2);

    if (intersectionPoints.empty()) {
        cout << "No intersection." << endl;
    } else {
        cout << "Intersection Points:" << endl;
        for (const Point& p : intersectionPoints) {
            cout << "x: " << p.x << ", y: " << p.y << endl;
        }
    }

    return 0;
}
```

## Puntos mas cercanos

```cpp
using namespace std;

const double EPS = 1e-9;

struct Point {
    double x, y;

    Point(double xx, double yy) : x(xx), y(yy) {}

    double dist(const Point& pt) const {
        double dx = x - pt.x, dy = y - pt.y;
        return sqrt(dx * dx + dy * dy);
    }
};

struct XSort {
    bool operator()(const Point& pt1, const Point& pt2) const {
        if (abs(pt1.x - pt2.x) < EPS) return false;
        return (pt1.x < pt2.x);
    }
};

struct YXSort {
    bool operator()(const Point& pt1, const Point& pt2) const {
        if (abs(pt1.y - pt2.y) < EPS) {
            if (abs(pt1.x - pt2.x) < EPS) return false;
            return (pt1.x < pt2.x);
        }
        return (pt1.y < pt2.y);
    }
};

vector<Point> closestPair(vector<Point>& points) {
    if (points.empty() || points.size() < 2) return vector<Point>();

    int n = points.size();
    int xQueueFront = 0, xQueueBack = 0;

    sort(points.begin(), points.end(), XSort());
    set<Point, YXSort> yWorkingSet;

    Point pt1(0, 0), pt2(0, 0);
    double d = numeric_limits<double>::max();

    for (int i = 0; i < n; i++) {
        Point nextPoint = points[i];

        while (xQueueFront != xQueueBack && nextPoint.x - points[xQueueFront].x > d) {
            Point pt = points[xQueueFront++];
            yWorkingSet.erase(pt);
        }

        double upperBound = nextPoint.y + d;
        auto next = yWorkingSet.upper_bound(nextPoint);
        while (next != yWorkingSet.end() && next->y <= upperBound) {
            double dist = nextPoint.dist(*next);
            if (dist < d) {
                pt1 = nextPoint;
                pt2 = *next;
                d = dist;
            }
            next++;
        }

        double lowerBound = nextPoint.y - d;
        next = yWorkingSet.lower_bound(Point(0, lowerBound));
        while (next != yWorkingSet.end() && next->y > lowerBound) {
            double dist = nextPoint.dist(*next);
            if (dist < d) {
                pt1 = nextPoint;
                pt2 = *next;
                d = dist;
            }
            next++;
        }

        if (yWorkingSet.count(nextPoint)) {
            pt1 = pt2 = nextPoint;
            d = 0;
            break;
        }

        yWorkingSet.insert(nextPoint);
        xQueueBack++;
    }

    return {pt1, pt2};
}

int main() {
    vector<Point> points = {Point(0, 0), Point(1, 1), Point(2, 2), Point(3, 3)};
    vector<Point> closest = closestPair(points);

    if (closest.size() == 2) {
        cout << closest[0].x << " " << closest[0].y << " " << closest[1].x << " " << closest[1].y << endl;
    } else {
        cout << "No closest pair found." << endl;
    }

    return 0;
}
```

## Determinar si 3 puntos son coliniales

Estan en el misma linea

```cpp
const double EPS = 1e-9;

int collinear(const pair<double, double>& a, const pair<double, double>& b, const pair<double, double>& c) {
    if (hypot(b.first - a.first, b.second - a.second) < EPS) {
        throw invalid_argument("a cannot equal b");
    }

    double v1_x = b.first - a.first;
    double v1_y = b.second - a.second;
    double v2_x = c.first - a.first;
    double v2_y = c.second - a.second;

    double determinant = (v1_x * v2_y) - (v2_x * v1_y);

    if (abs(determinant) < EPS) {
        return 0;
    }

    return (determinant < 0 ? -1 : 1);
}

int main() {
    pair<double, double> a = make_pair(1, 1);
    pair<double, double> b = make_pair(3, 3);
    pair<double, double> c = make_pair(7, 7);

    // Returns 0 means that yes these points are collinear
    cout << collinear(a, b, c) << endl;

    // Returns +1 meaning that c is to the left of the line
    c = make_pair(2, 7);
    cout << collinear(a, b, c) << endl;

    // Returns -1 meaning that c is to the right of the line
    c = make_pair(2, -7);
    cout << collinear(a, b, c) << endl;

    return 0;
}
```

## Determinar si puntos 3D son coplanos

En el mismo plano

```cpp
const double EPS = 1e-7;

struct Vector {
    double x, y, z;
    Vector(double xx, double yy, double zz) : x(xx), y(yy), z(zz) {}
};

Vector cross(const Vector& v1, const Vector& v2) {
    double v3x = v1.y * v2.z - v1.z * v2.y;
    double v3y = v1.z * v2.x - v1.x * v2.z;
    double v3z = v1.x * v2.y - v1.y * v2.x;
    return Vector(v3x, v3y, v3z);
}

double dot(const Vector& v1, const Vector& v2) {
    return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z);
}

bool areCoplanar(
    double ax, double ay, double az,
    double bx, double by, double bz,
    double cx, double cy, double cz,
    double dx, double dy, double dz) {

    Vector v1(bx - ax, by - ay, bz - az);
    Vector v2(cx - ax, cy - ay, cz - az);
    Vector v3(dx - ax, dy - ay, dz - az);

    Vector v4 = cross(v1, v2);

    return abs(dot(v3, v4)) < EPS;
}

int main() {
    cout << "The points (0,0,0), (1,0,1), (0,1,1), (1,1,2) are coplanar: " <<
        areCoplanar(0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 2) << endl;

    cout << "The points (0,0,0), (3,3,3), (3,0,0), (0,4,0) are coplanar: " <<
        areCoplanar(0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 4, 0) << endl;

    cout << "The points (0,0,0), (1,1,1), (2,2,2), (3,3,3) are coplanar: " <<
        areCoplanar(0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3) << endl;

    return 0;
}
```

## Intereseccion de una linea con un circulo

```cpp
const double EPS = 1e-9;

vector<pair<double, double>> lineCircleIntersection(
    double a, double b, double c, double x, double y, double r);

void display(const vector<pair<double, double>>& pts);

int main() {
    // Vertical Line passing through (1,0)
    auto result1 = lineCircleIntersection(1, 0, 1, 0, 0, 1);
    display(result1);

    // Horizontal line passing through (0,1)
    auto result2 = lineCircleIntersection(0, 1, 1, 0, 0, 1);
    display(result2);

    // Vertical line passing through (-1,0)
    auto result3 = lineCircleIntersection(1, 0, -1, 0, 0, 1);
    display(result3);

    return 0;
}

void display(const vector<pair<double, double>>& pts) {
    if (pts.empty()) {
        cout << "No intersection points" << endl;
    } else if (pts.size() == 1) {
        cout << "Tangent point: (" << pts[0].first << ", " << pts[0].second << ")" << endl;
    } else {
        cout << "Intersection points:" << endl;
        for (const auto& p : pts) {
            cout << "(" << p.first << ", " << p.second << ")" << endl;
        }
    }
}

vector<pair<double, double>> lineCircleIntersection(
    double a, double b, double c, double x, double y, double r) {
    double A = a * a + b * b;
    double B = 2 * a * b * y - 2 * a * c - 2 * b * b * x;
    double C = b * b * x * x + b * b * y * y - 2 * b * c * y + c * c - b * b * r * r;
    double D = B * B - 4 * A * C;
    double x1, y1, x2, y2;
    // Vertical line case :0
    if (abs(b) < EPS) {
        // ax + by = c, but b = 0, so x = c/a
        double vx = c / a;
        // No intersection
        if (abs(x - vx) > r) return {};
        // Vertical line is tangent to circle
        if (abs((vx - r) - x) < EPS || abs((vx + r) - x) < EPS)
            return {{vx, y}};
        double dx = abs(vx - x);
        double dy = sqrt(r * r - dx * dx);
        return {{vx, y + dy}, {vx, y - dy}};
        // Line is tangent to circle
    }
    else if (abs(D) < EPS) {
        x1 = -B / (2 * A);
        y1 = (c - a * x1) / b;
        return {{x1, y1}};
        // No intersection point
    }
    else if (D < 0) {
        return {};
    }
    else {
        D = sqrt(D);
        x1 = (-B + D) / (2 * A);
        y1 = (c - a * x1) / b;
        x2 = (-B - D) / (2 * A);
        y2 = (c - a * x2) / b;
        return {{x1, y1}, {x2, y2}};
    }
}
```

## Convertir puntos a forma general

ax + b + c = 0

```cpp
void segmentToGeneralForm(double x1, double y1, double x2, double y2, double &a, double &b, double &c) {
    a = y1 - y2;
    b = x2 - x1;
    c = x1 * y2 - y1 * x2;
}

int main() {
    double a, b, c;
    segmentToGeneralForm(1, 1, 3, -4, a, b, c);
    cout << fixed;
    cout.precision(2);
    cout << a << "x + " << b << "y + " << c << " = 0" << endl;
    
    return 0;
}
```

## Distancia entre coordenadas geograficas

```cpp

// Compute the distance between geographic coordinates in units
  // of its radii (multiply by 6371km for Earth)
double dist(double lat1, double lon1, double lat2, double lon2) {
    double dLat = radians(lat2 - lat1);
    double dLon = radians(lon2 - lon1);
    double a =
        sin(dLat / 2.0) * sin(dLat / 2.0)
        + cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon / 2.0) * sin(dLon / 2.0);
    return 2.0 * atan2(sqrt(a), sqrt(1 - a));
}
```

## Area de Triangulo

```cpp
double triangleArea(double side1, double side2, double side3) {
    double s = (side1 + side2 + side3) / 2.0;
    return sqrt(s * (s - side1) * (s - side2) * (s - side3));
}

double triangleArea(double ax, double ay, double bx, double by, double cx, double cy) {
    double v1_x = bx - ax;
    double v1_y = by - ay;
    double v2_x = cx - ax;
    double v2_y = cy - ay;

    double determinant = v1_x * v2_y - v2_x * v1_y;

    return abs(determinant) / 2.0;
}

int main() {
    double ax = 0, ay = 1;
    double bx = 2, by = 0;
    double cx = 3, cy = 4;

    cout << triangleArea(ax, ay, bx, by, cx, cy) << endl;

    double side1 = hypot(bx - ax, by - ay);
    double side2 = hypot(cx - ax, cy - ay);
    double side3 = hypot(bx - cx, by - cy);

    cout << triangleArea(side1, side2, side3) << endl;

    return 0;
}
```

## Interseccion punto con Circulo

Given a circle and a point around or inside the circle we wish to find place(s) of intersection
of the lines from the point which are tangent to the circle.

```cpp
struct Point {
    double x, y;
    Point(double x = 0, double y = 0) : x(x), y(y) {}
};

const double EPS = 0.0000001;

double arcsinSafe(double x) {
    if (x <= -1.0) return -M_PI / 2.0;
    if (x >= +1.0) return +M_PI / 2.0;
    return asin(x);
}

vector<Point> pointCircleTangentPoints(Point center, double radius, Point pt) {
    double px = pt.x, py = pt.y;
    double cx = center.x, cy = center.y;

    double dx = cx - px;
    double dy = cy - py;
    double dist = sqrt(dx * dx + dy * dy);

    if (dist < radius) return vector<Point>();

    double angle1, angle2;

    angle1 = arcsinSafe(radius / dist);
    angle2 = atan2(dy, dx);

    double angle = angle2 - angle1;
    Point p1(cx + radius * sin(angle), cy + radius * -cos(angle));

    angle = angle1 + angle2;
    Point p2(cx + radius * -sin(angle), cy + radius * cos(angle));

    if (hypot(p1.x - p2.x, p1.y - p2.y) < EPS) return vector<Point>{pt};

    return vector<Point>{p1, p2};
}

int main() {
    double radius = 2.0;
    Point circleCenter(5, 0);
    Point origin(0, 0);

    vector<Point> points = pointCircleTangentPoints(circleCenter, radius, origin);

    if (points.size() == 2) {
        Point pt1 = points[0];
        Point pt2 = points[1];
        cout << "Points found: (" << pt1.x << ", " << pt1.y << ") (" << pt2.x << ", " << pt2.y << ")\n";
    }

    return 0;
}
```

## Rotar Puntos

```cpp
#include <iostream>
#include <cmath>

struct Point2D {
  double x, y;

  Point2D(double x, double y) : x(x), y(y) {}
};

// Rotate point 'pt' a certain number of radians clockwise
// relative to some fixed point 'fp'. Note that the angle
// should be specified in radians, not degrees.
Point2D rotatePoint(Point2D fp, Point2D pt, double angle) {
  double fpx = fp.x;
  double fpy = fp.y;
  double ptx = pt.x;
  double pty = pt.y;
  double x = ptx - fpx;
  double y = pty - fpy;
  double xRotated = x * cos(angle) + y * sin(angle);
  double yRotated = y * cos(angle) - x * sin(angle);

  return Point2D(fpx + xRotated, fpy + yRotated);
}

int main() {

  // Suppose we want to rotate the point (4,5) about the point
  // (3, 5) 45 degrees (pi/4 radians) clockwise 8 times until
  // it cycles back to its original position:

  double angle = M_PI / 4.0;
  Point2D fixedPoint(3, 5);
  Point2D point(4, 5);

  // Prints all 8 rotations
  Point2D rotatedPoint = point;
  for (int i = 0; i < 8; i++) {
    cout << "Rotated point is now at: (" << rotatedPoint.x << ", " << rotatedPoint.y << ")\n";
    rotatedPoint = rotatePoint(fixedPoint, rotatedPoint, angle);
  }
  cout << "Rotated point is now at: (" << rotatedPoint.x << ", " << rotatedPoint.y << ")\n";

  return 0;
}

```