//Can do booleanean operations on all types polygons
//From the report "Efficient clipping of arbitrary polygons"
//Assumes there are no degeneracies (each vertex of one polygon does not lie on an edge of the other polygon)
public static class GreinerHormann
{
    public static ArrayList<ArrayList<PVector>> ClipPolygons(ArrayList<PVector> polyVector2, ArrayList<PVector> clipPolyVector2, BooleanOperation booleanOperation)
    {
        ArrayList<ArrayList<PVector>> finalPoly = new ArrayList<ArrayList<PVector>>();



        //Step 0. Create the data structure needed
        ArrayList<ClipVertex> poly = InitDataStructure(polyVector2);

        ArrayList<ClipVertex> clipPoly = InitDataStructure(clipPolyVector2);



        //Step 1. Find intersection points
        //Need to test if we have found an intersection point, 
        //if none is found, the polygons dont intersect, or one polygon is inside the other
        boolean hasFoundIntersection = false;

        for (int i = 0; i < poly.size(); i++)
        {
            ClipVertex currentVertex = poly.get(i);

            //Important to use iPlusOne because poly.next may change
            int iPlusOne = MathUtility.ClampListIndex(i + 1, poly.size());

            PVector a = poly.get(i).coordinate;

            PVector b = poly.get(iPlusOne).coordinate;

            //Gizmos.DrawWireSphere(poly.get(i).coordinate, 0.02f);
            //Gizmos.DrawWireSphere(poly.get(i).next.coordinate, 0.02f);

            for (int j = 0; j < clipPoly.size(); j++)
            {
                int jPlusOne = MathUtility.ClampListIndex(j + 1, clipPoly.size());

                PVector c = clipPoly.get(j).coordinate;

                PVector d = clipPoly.get(jPlusOne).coordinate;

                //Are these lines intersecting?
                if (_Intersections.LineLine(a, b, c, d, true))
                {
                    hasFoundIntersection = true;

                    PVector intersectionPoint2D = _Intersections.GetLineLineIntersectionPoint(a, b, c, d);

                    //Vector3 intersectionPoint = new Vector3(intersectionPoint2D.x, 0f, intersectionPoint2D.y);

                    //Gizmos.color = Color.red;

                    //Gizmos.DrawWireSphere(intersectionPoint, 0.04f);

                    //We need to insert this intersection vertex into both polygons
                    //Insert into the polygon
                    ClipVertex vertexOnPolygon = InsertIntersectionVertex(a, b, intersectionPoint2D, currentVertex);

                    //Insert into the clip polygon
                    ClipVertex vertexOnClipPolygon = InsertIntersectionVertex(c, d, intersectionPoint2D, clipPoly.get(j));

                    //Also connect the intersection vertices with each other
                    vertexOnPolygon.neighbor = vertexOnClipPolygon;

                    vertexOnClipPolygon.neighbor = vertexOnPolygon;
                }
            }
        }


        //Debug in which order the vertices are in the linked ArrayList
        //InWhichOrderAreVerticesAdded(poly);

        //InWhichOrderAreVerticesAdded(clipPoly);



        //If the polygons are intersecting
        if (hasFoundIntersection)
        {
            //Step 2. Trace each polygon and mark entry and exit points to the other polygon's interior
            MarkEntryExit(poly, clipPolyVector2);

            MarkEntryExit(clipPoly, polyVector2);
            
            //Step 3. Create the desired clipped polygon
            if (booleanOperation == booleanOperation.Intersection)
            {
                //Where the two polygons intersect
                ArrayList<ClipVertex> intersectionVertices = GetClippedPolygon(poly, true);

                //println(intersectionVertices.size());

                AddPolygonToList(intersectionVertices, finalPoly, false);

                //println();
            }
            else if (booleanOperation == booleanOperation.Difference)
            {
                //Whats outside of the polygon that doesnt intersect
                ArrayList<ClipVertex> outsidePolyVertices = GetClippedPolygon(poly, false);

                AddPolygonToList(outsidePolyVertices, finalPoly, true);
            }
            else if (booleanOperation == booleanOperation.ExclusiveOr)
            {
                //Whats outside of the polygon that doesnt intersect
                ArrayList<ClipVertex> outsidePolyVertices = GetClippedPolygon(poly, false);

                AddPolygonToList(outsidePolyVertices, finalPoly, true);

                //Whats outside of the polygon that doesnt intersect
                ArrayList<ClipVertex> outsideClipPolyVertices = GetClippedPolygon(clipPoly, false);

                AddPolygonToList(outsideClipPolyVertices, finalPoly, true);
            }
            else if (booleanOperation == booleanOperation.Union)
            {
                //Where the two polygons intersect
                ArrayList<ClipVertex> intersectionVertices = GetClippedPolygon(poly, true);

                AddPolygonToList(intersectionVertices, finalPoly, false);

                //Whats outside of the polygon that doesnt intersect
                ArrayList<ClipVertex> outsidePolyVertices = GetClippedPolygon(poly, false);

                AddPolygonToList(outsidePolyVertices, finalPoly, true);

                //Whats outside of the polygon that doesnt intersect
                ArrayList<ClipVertex> outsideClipPolyVertices = GetClippedPolygon(clipPoly, false);

                AddPolygonToList(outsideClipPolyVertices, finalPoly, true);
            }

            //Where the two polygons intersect
            //ArrayList<ClipVertex> intersectionVertices = GetClippedPolygon(poly, true);
            //Whats outside of the polygon that doesnt intersect
            //These will be in clockwise order so remember to change to counter clockwise
            //ArrayList<ClipVertex> outsidePolyVertices = GetClippedPolygon(poly, false);
            //ArrayList<ClipVertex> outsideClipPolyVertices = GetClippedPolygon(clipPoly, false);
        }
        //Check if one polygon is inside the other
        else
        {
            //Is the polygon inside the clip polygon?
            //Depending on the type of booleanean operation, we might get a hole
            if (IsPolygonInsidePolygon(polyVector2, clipPolyVector2))
            {
                println("Poly is inside clip poly");
            }
            else if (IsPolygonInsidePolygon(clipPolyVector2, polyVector2))
            {
                println("Clip poly is inside poly");
            }
            else
            {
                println("Polygons are not intersecting");
            }
        }

        return finalPoly;
    }



    //We may end up with several polygons, so this will split the connected ArrayList into one ArrayList per polygon
    private static void AddPolygonToList(ArrayList<ClipVertex> verticesToAdd, ArrayList<ArrayList<PVector>> finalPoly, boolean shouldReverse)
    {
        ArrayList<PVector> thispolyList = new ArrayList<PVector>();

        finalPoly.add(thispolyList);

        for (int i = 0; i < verticesToAdd.size(); i++)
        {
            ClipVertex v = verticesToAdd.get(i);

            thispolyList.add(v.coordinate);

            //Have we found a new polygon?
            if (v.nextPoly != null)
            {
                //If we are finding the !intersection, the vertices will be clockwise
                //so we should reverse the ArrayList to make it easier to triangulate
                if (shouldReverse)
                {
                    thispolyList = reverse(thispolyList);
                }

                thispolyList = new ArrayList<PVector>();

                finalPoly.add(thispolyList);

                //println("test");
            }

            //println(v.nextPoly);
        }

        //Reverse the last ArrayList added
        if (shouldReverse)
        {
            finalPoly.set(finalPoly.size() - 1, reverse(finalPoly.get(finalPoly.size() - 1)));
        }
    }



    //Get the clipped polygons: either the intersection or the !intersection
    //We might end up with more than one polygon and they are connected via clipvertex nextpoly
    //To get the intersection, we should
    //Traverese the polygon until an intersection is encountered. Add this intersection to the clipped polygon. 
    //Traversal direction is determined by the entry/exit boolean. 
    // - If the intersection is an entry, move forward along the current polygon 
    // - If the intersection is an exit, then change polygon, proceed in the backward direction of the other polygon 
    // - Change polygon if a new intersection is found
    //If we want to the !intersection, we just travel in the reverse direction from the first intersection vertex
    private static ArrayList<ClipVertex> GetClippedPolygon(ArrayList<ClipVertex> poly, boolean getIntersectionPolygon)
    {
        ArrayList<ClipVertex> finalPolygon = new ArrayList<ClipVertex>();


        //First we have to reset in case we are repeating this method several times depending on the type of booleanean operation
        ResetVertices(poly);


        //Find the first intersection point which is always where we start
        ClipVertex thisVertex = FindFirstEntryVertex(poly);

        //Save this so we know when to stop the algortihm
        ClipVertex firstVertex = thisVertex;

        finalPolygon.add(thisVertex);

        thisVertex.isTakenByFinalPolygon = true;
        thisVertex.neighbor.isTakenByFinalPolygon = true;

        //These rows is the only part thats different if we want to get the intersection or the !intersection
        //Are needed once again if there are more than one polygon
        boolean isMovingForward = getIntersectionPolygon ? true : false;

        thisVertex = getIntersectionPolygon ? thisVertex.next : thisVertex.prev;

        int safety = 0;

        while (true)
        {
            if (thisVertex == firstVertex || (thisVertex.neighbor != null && thisVertex.neighbor == firstVertex))
            {
                //println("Found a polygon with: " + finalPolygon.size() + " vertices");

                //println("Intersection vertices: " + intersectionVertices.size());

                //Try to find the next intersection point in case we end up with more than one polygon 
                ClipVertex nextVertex = FindFirstEntryVertex(poly);

                //Stop if we are out of intersection vertices
                if (nextVertex == null)
                {
                    //println("No more polygons can be found");

                    break;
                }
                //Find an entry vertex and start over with another polygon
                else
                {
                    //println("Find another polygon");

                    //println(thisVertex.nextPoly);

                    //Need to connect the polygons
                    finalPolygon.get(finalPolygon.size() - 1).nextPoly = nextVertex;


                    //Change to a new polygon
                    thisVertex = nextVertex;

                    firstVertex = nextVertex;

                    finalPolygon.add(thisVertex);

                    thisVertex.isTakenByFinalPolygon = true;
                    thisVertex.neighbor.isTakenByFinalPolygon = true;

                    //Do we want to get the intersection or the !intersection
                    isMovingForward = getIntersectionPolygon ? true : false;

                    thisVertex = getIntersectionPolygon ? thisVertex.next : thisVertex.prev;
                }
            }


            //If this is not an intersection, then just add it
            if (!thisVertex.isIntersection)
            {
                finalPolygon.add(thisVertex);

                //And move in the direction we are moving
                thisVertex = isMovingForward ? thisVertex.next : thisVertex.prev;
            }
            else
            {
                thisVertex.isTakenByFinalPolygon = true;
                thisVertex.neighbor.isTakenByFinalPolygon = true;

                //Jump to the other polygon
                thisVertex = thisVertex.neighbor;

                finalPolygon.add(thisVertex);

                //Move forward/ back depending on if this is an entry / exit vertex and if we want to find the intersection or not
                if (getIntersectionPolygon)
                {
                    isMovingForward = thisVertex.isEntry ? true : false;

                    thisVertex = thisVertex.isEntry ? thisVertex.next : thisVertex.prev;
                }
                else
                {
                    isMovingForward = !isMovingForward;

                    thisVertex = isMovingForward ? thisVertex.next : thisVertex.prev;
                }
            }

            safety += 1;

            if (safety > 100000)
            {
                println("Endless loop when creating clipped polygon");

                //println(isMovingForward);

                break;
            }
        }


        //Debug
        //float size = 0.02f;

        //for (int i = 0; i < finalPolygon.size(); i++)
        //{
        //    int iMinusOne = MathUtility.ClampListIndex(i - 1, finalPolygon.size());

        //    Vector3 v1 = new Vector3(finalPolygon.get(i).coordinate.x, 0f, finalPolygon.get(i).coordinate.y);

        //    Vector3 v2 = new Vector3(finalPolygon[iMinusOne].coordinate.x, 0f, finalPolygon[iMinusOne].coordinate.y);

        //    Gizmos.color = Color.white;

        //    Gizmos.DrawWireSphere(v1, size);

        //    Gizmos.DrawLine(v1, v2);

        //    size += 0.005f;
        //}

        //println(finalPolygon.size());

        return finalPolygon;
    }



    //Reset vertices before we find the final polygon(s)
    private static void ResetVertices(ArrayList<ClipVertex> poly)
    {
        ClipVertex resetVertex = poly.get(0);

        int safety = 0;

        while (true)
        {
            //Reset
            resetVertex.isTakenByFinalPolygon = false;
            resetVertex.nextPoly = null;

            //Dont forget to reset the neighbor
            if (resetVertex.isIntersection)
            {
                resetVertex.neighbor.isTakenByFinalPolygon = false;
            }

            resetVertex = resetVertex.next;

            //All vertices are reset
            if (resetVertex == poly.get(0))
            {
                break;
            }

            safety += 1;

            if (safety > 100000)
            {
                println("Endless loop in reset vertices");

                break;
            }
        }
    }



    //Is a polygon One inside polygon Two?
    private static boolean IsPolygonInsidePolygon(ArrayList<PVector> polyOne, ArrayList<PVector> polyTwo)
    {
        boolean isInside = false;

        for (int i = 0; i < polyOne.size(); i++)
        {
            if (_Intersections.PointPolygon(polyTwo, polyOne.get(i)))
            {
                //Is inside if at least one point is inside the polygon. We run this method after we have tested
                //if the polygons are intersecting
                isInside = true;

                break;
            }
        }

        return isInside;
    }



    //Find the the first entry vertex in a polygon
    private static ClipVertex FindFirstEntryVertex(ArrayList<ClipVertex> poly)
    {
        ClipVertex thisVertex = poly.get(0);

        ClipVertex firstVertex = thisVertex;

        int safety = 0;

        while (true)
        {
            //Is this an available entry vertex?
            if (thisVertex.isIntersection && thisVertex.isEntry && !thisVertex.isTakenByFinalPolygon)
            {
                //We have found the first vertex
                break;
            }

            thisVertex = thisVertex.next;

            //We have travelled the entire polygon without finding an available entry vertex
            if (thisVertex == firstVertex)
            {
                thisVertex = null;

                break;
            }

            safety += 1;

            if (safety > 100000)
            {
                println("Endless loop in find first entry vertex");

                break;
            }
        }

        return thisVertex;
    }



    //Create the data structure needed
    private static ArrayList<ClipVertex> InitDataStructure(ArrayList<PVector> polyVector)
    {
        ArrayList<ClipVertex> poly = new ArrayList<ClipVertex>();

        for (int i = 0; i < polyVector.size(); i++)
        {PVector p = polyVector.get(i);
            poly.add(new ClipVertex(p));
        }

        //Connect the vertices
        for (int i = 0; i < poly.size(); i++)
        {
            int iPlusOne = MathUtility.ClampListIndex(i + 1, poly.size());
            int iMinusOne = MathUtility.ClampListIndex(i - 1, poly.size());

            poly.get(i).next = poly.get(iPlusOne);
            poly.get(i).prev = poly.get(iMinusOne);
        }

        return poly;
    }



    //Insert intersection vertex
    private static ClipVertex InsertIntersectionVertex(PVector a, PVector b, PVector intersectionPoint, ClipVertex currentVertex)
    {
        //Calculate alpha which is how far the intersection coordinate is between a and b
        //so we can insert this vertex at the correct position
        //pos = start + dir * alpha
        float alpha = pow(PVector.sub(a, intersectionPoint).mag(), 2) / pow(PVector.sub(a, b).mag(), 2);

        //println(alpha);

        //Create a new vertex
        ClipVertex intersectionVertex = new ClipVertex(intersectionPoint);

        intersectionVertex.isIntersection = true;
        intersectionVertex.alpha = alpha;

        //Now we need to insert this intersection point somewhere after currentVertex
        ClipVertex insertAfterThisVertex = currentVertex;

        int safety = 0;

        while (true)
        {
            //If the next vertex is an intersectionvertex with a higher alpha 
            //or if the next vertex is not an intersectionvertex, we cant improve, so break
            if (insertAfterThisVertex.next.alpha > alpha || !insertAfterThisVertex.next.isIntersection)
            {
                break;
            }

            insertAfterThisVertex = insertAfterThisVertex.next;

            safety += 1;

            if (safety > 100000)
            {
                println("Stuck in loop in insert intersection vertices");

                break;
            }
        }

        //Connect the vertex to the surrounding vertices
        intersectionVertex.next = insertAfterThisVertex.next;

        intersectionVertex.prev = insertAfterThisVertex;

        insertAfterThisVertex.next.prev = intersectionVertex;

        insertAfterThisVertex.next = intersectionVertex;

        return intersectionVertex;
    }



    //Mark entry exit points
    private static void MarkEntryExit(ArrayList<ClipVertex> poly, ArrayList<PVector> clipPolyVector)
    {
        //First see if the first vertex starts inside or outside (we can use the original ArrayList)
        boolean isInside = _Intersections.PointPolygon(clipPolyVector, poly.get(0).coordinate);

        //println(isInside);

        ClipVertex currentVertex = poly.get(0);

        ClipVertex firstVertex = currentVertex;

        int safety = 0;

        while (true)
        {
            if (currentVertex.isIntersection)
            {
                //If we were outside, this is an entry
                currentVertex.isEntry = isInside ? false : true;

                //Now we know we are either inside or outside
                isInside = !isInside;
            }

            currentVertex = currentVertex.next;

            //We have travelled around the entire polygon
            if (currentVertex == firstVertex)
            {
                break;
            }

            safety += 1;

            if (safety > 100000)
            {
                println("Endless loop in mark entry exit");

                break;
            }
        }
    }

    private static void InWhichOrderAreVerticesAdded(ArrayList<ClipVertex> polyList)
    {
        ClipVertex thisVertex = polyList.get(0);

        float size = 0.01f;

        int safety = 0;

        while (true)
        {

            //Gizmos.DrawWireSphere(new Vector3(thisVertex.coordinate.x, 0f, thisVertex.coordinate.y), size);

            size += 0.01f;

            thisVertex = thisVertex.next;

            //We are back at the first vertex
            if (thisVertex == polyList.get(0))
            {
                break;
            }

            safety += 1;

            if (safety > 100000)
            {
                println("Endless loop in debug in which orders are vertices added");

                break;
            }
        }
    }
    
    public static ArrayList<PVector> reverse(ArrayList<PVector> target){
      ArrayList<PVector> result = new ArrayList<PVector>();
      for(int i = 0; i < target.size(); i++){
        result.add(target.get(target.size()-i-1));
      }
      return result;
    }
}