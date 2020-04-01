//Help enum, to make it easier to deal with three cases: intersecting inside, intersecting on edge, not intersecting 
//If we have two cases we can just return a boolean
public enum IntersectionCases
{
    IsInside,
    IsOnEdge,
    NoIntersection
}

public static class _Intersections
{
    //
    // Are two lines intersecting?
    //
    //http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
    //Notice that there are more than one way to test if two line segments are intersecting
    //but this is the fastest according to https://www.habrador.com/tutorials/math/5-line-line-intersection/
    public static boolean LineLine(PVector l1_p1, PVector l1_p2, PVector l2_p1, PVector l2_p2, boolean shouldIncludeEndPoints)
    {
        //To avoid floating point precision issues we can use a small value
        float epsilon = EPSILON;

        boolean isIntersecting = false;

        float denominator = (l2_p2.y - l2_p1.y) * (l1_p2.x - l1_p1.x) - (l2_p2.x - l2_p1.x) * (l1_p2.y - l1_p1.y);

        //Make sure the denominator is > 0, if so the lines are parallel
        if (denominator != 0f)
        {
            float u_a = ((l2_p2.x - l2_p1.x) * (l1_p1.y - l2_p1.y) - (l2_p2.y - l2_p1.y) * (l1_p1.x - l2_p1.x)) / denominator;
            float u_b = ((l1_p2.x - l1_p1.x) * (l1_p1.y - l2_p1.y) - (l1_p2.y - l1_p1.y) * (l1_p1.x - l2_p1.x)) / denominator;

            //Are the line segments intersecting if the end points are the same
            if (shouldIncludeEndPoints)
            {
                //Is intersecting if u_a and u_b are between 0 and 1 or exactly 0 or 1
                if (u_a >= 0f + epsilon && u_a <= 1f - epsilon && u_b >= 0f + epsilon && u_b <= 1f - epsilon)
                {
                    isIntersecting = true;
                }
            }
            else
            {
                //Is intersecting if u_a and u_b are between 0 and 1
                if (u_a > 0f + epsilon && u_a < 1f - epsilon && u_b > 0f + epsilon && u_b < 1f - epsilon)
                {
                    isIntersecting = true;
                }
            }

        }

        return isIntersecting;
    }



    //Whats the coordinate of an intersection point between two lines in 2d space if we know they are intersecting
    //http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
    public static PVector GetLineLineIntersectionPoint(PVector l1_p1, PVector l1_p2, PVector l2_p1, PVector l2_p2)
    {
        float denominator = (l2_p2.y - l2_p1.y) * (l1_p2.x - l1_p1.x) - (l2_p2.x - l2_p1.x) * (l1_p2.y - l1_p1.y);

        float u_a = ((l2_p2.x - l2_p1.x) * (l1_p1.y - l2_p1.y) - (l2_p2.y - l2_p1.y) * (l1_p1.x - l2_p1.x)) / denominator;

        PVector intersectionPoint = PVector.add(l1_p1, PVector.mult((PVector.sub(l1_p2, l1_p1)), u_a));

        return intersectionPoint;
    }
    
     //
    // Is a point intersecting with a polygon?
    //
    //The list describing the polygon has to be sorted either clockwise or counter-clockwise because we have to identify its edges
    //TODO: May sometimes fail because of floating point precision issues
    public static boolean PointPolygon(ArrayList<PVector> polygonPoints, PVector point)
    {
    //Step 1. Find a point outside of the polygon
    //Pick a point with a x position larger than the polygons max x position, which is always outside
    PVector maxXPosVertex = polygonPoints.get(0);

    for (int i = 1; i < polygonPoints.size(); i++)
    {
        if (polygonPoints.get(i).x > maxXPosVertex.x)
        {
            maxXPosVertex = polygonPoints.get(i);
        }
    }

    //The point should be outside so just pick a number to move it outside
    //Should also move it up a little to minimize floating point precision issues
    //This is where it fails if this line is exactly on a vertex
    PVector pointOutside = PVector.add(maxXPosVertex, new PVector(1f, 0.01f));


    //Step 2. Create an edge between the point we want to test with the point thats outside
    PVector l1_p1 = point;
    PVector l1_p2 = pointOutside;

    //Debug.DrawLine(l1_p1.XYZ(), l1_p2.XYZ());


    //Step 3. Find out how many edges of the polygon this edge is intersecting with
    int numberOfIntersections = 0;

    for (int i = 0; i < polygonPoints.size(); i++)
    {
        //Line 2
        PVector l2_p1 = polygonPoints.get(i);

        int iPlusOne = MathUtility.ClampListIndex(i + 1, polygonPoints.size());

        PVector l2_p2 = polygonPoints.get(iPlusOne);

        //Are the lines intersecting?
        if (_Intersections.LineLine(l1_p1, l1_p2, l2_p1, l2_p2, true))
        {
            numberOfIntersections += 1;
        }
    }


    //Step 4. Is the point inside or outside?
    boolean isInside = true;

    //The point is outside the polygon if number of intersections is even or 0
    if (numberOfIntersections == 0 || numberOfIntersections % 2 == 0)
    {
        isInside = false;
    }

    return isInside;
    }
}