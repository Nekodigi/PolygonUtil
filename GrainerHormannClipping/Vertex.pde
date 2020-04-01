//Same structure as in the report
//Should maybe extend from Vertex class?
public static class ClipVertex
{
    public PVector coordinate;

    //Next and previous vertex in the chain that will form a polygon if we walk around it
    public ClipVertex next;
    public ClipVertex prev;

    //We may end up with more than one polygon, and this means we jump to that polygon from this polygon
    public ClipVertex nextPoly;

    //True if this is an intersection vertex
    public boolean isIntersection = false;

    //Is an intersect an entry to a neighbor polygon, otherwise its an exit from a polygon
    public boolean isEntry;

    //If this is an intersection vertex, then this is the same intersection vertex but on the other polygon
    public ClipVertex neighbor;

    //HIf this is an intersection vertex, this is how far is is between two vertices that are not intersecting
    public float alpha = 0f;

    //Is this vertex taken by the final polygon, which is more efficient than removing from a ArrayList
    //when we create the final polygon
    public boolean isTakenByFinalPolygon;

    ClipVertex(PVector coordinate)
    {
        this.coordinate = coordinate;
    }
}