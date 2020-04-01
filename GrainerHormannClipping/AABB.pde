//Axis-Aligned-Bounding-Box, which is a rectangle in 2d space aligned along the x and y axis
class AABB2
{
    public float minX;
    public float maxX;
    public float minY;
    public float maxY;


    //We know the min and max values
    public AABB2(float minX, float maxX, float minY, float maxY)
    {
        this.minX = minX;
        this.maxX = maxX;
        this.minY = minY;
        this.maxY = maxY;
    }


    //We have a list with points and want to find the min and max values
    public AABB2(ArrayList<PVector> points)
    {
        PVector p1 = points.get(0);

        float minX = p1.x;
        float maxX = p1.x;
        float minY = p1.y;
        float maxY = p1.y;

        for (int i = 1; i < points.size(); i++)
        {
            PVector p = points.get(i);

            if (p.x < minX)
            {
                minX = p.x;
            }
            else if (p.x > maxX)
            {
                maxX = p.x;
            }

            if (p.y < minY)
            {
                minY = p.y;
            }
            else if (p.y > maxY)
            {
                maxY = p.y;
            }
        }

        this.minX = minX;
        this.maxX = maxX;
        this.minY = minY;
        this.maxY = maxY;
    }
}