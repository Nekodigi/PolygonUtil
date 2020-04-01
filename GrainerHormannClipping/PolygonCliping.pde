class PolygonClippingController
{
    Polygon polyA;
    Polygon polyB;
    
    PolygonClippingController(Polygon polyA, Polygon polyB){
      this.polyA = polyA;
      this.polyB = polyB;
    }
    
    void show()
    {
        //Display the original polygons
        polyA.show(color(255));
        polyB.show(color(0, 0, 255));

        ArrayList<PVector> poly = polyB.vertices;
        ArrayList<PVector> clipPoly = polyA.vertices;

        //Clipping algortihms
        //Algortihm 1.Sutherland-Hodgman will return the intersection of the polygons
        //Requires that the clipping polygon (the polygon we want to remove from the other polygon) is convex
        //TestSutherlandHodgman(poly, clipPoly);



        //Alorithm 2. Greiner-Hormann. Can do all boolean operations on all types of polygons
        //but fails when a vertex is on the other polygon's edge
        TestGreinerHormann(poly, clipPoly);
    }

    void TestGreinerHormann(ArrayList<PVector> poly, ArrayList<PVector> clipPoly)
    {
        //Normalize to range 0-1
        //We have to use all data to normalize
        ArrayList<PVector> allPoints = new ArrayList<PVector>();
        allPoints.addAll(poly);
        allPoints.addAll(clipPoly);

        AABB2 normalizingBox = new AABB2(allPoints);

        float dMax = HelpMethods.CalculateDMax(normalizingBox);

        ArrayList<PVector> poly_normalized = HelpMethods.Normalize(poly, normalizingBox, dMax);

        ArrayList<PVector> clipPoly_normalized = HelpMethods.Normalize(clipPoly, normalizingBox, dMax);



        //In this case we can get back multiple parts of the polygon because one of the 
        //polygons doesnt have to be convex
        //If you pick boolean operation: intersection you should get the same result as with the Sutherland-Hodgman
        ArrayList<ArrayList<PVector>> finalPolygon = GreinerHormann.ClipPolygons(poly_normalized, clipPoly_normalized, BooleanOperation.Intersection);

        println("Total polygons: " + finalPolygon.size());

        for (int i = 0; i < finalPolygon.size(); i++)
        {
            ArrayList<PVector> thisPolygon_normalized = finalPolygon.get(i);

            println("Vertices in this polygon: " + thisPolygon_normalized.size());

            //Unnormalized
            ArrayList<PVector> thisPolygon = HelpMethods.UnNormalize(thisPolygon_normalized, normalizingBox, dMax);
            
            //Display
            new Polygon(thisPolygon).show(color(255, 0, 0));
        }
    }
}