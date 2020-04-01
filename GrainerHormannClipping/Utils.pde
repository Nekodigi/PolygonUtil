//Standardized methods that are the same for all
public static class HelpMethods
{
    //
    // Normalize points to the range (0 -> 1)
    //
    //From "A fast algorithm for constructing Delaunay triangulations in the plane" by Sloan
    //boundingBox is the rectangle that covers all original points before normalization
    public static float CalculateDMax(AABB2 boundingBox)
    {
        float dMax = max(boundingBox.maxX - boundingBox.minX, boundingBox.maxY - boundingBox.minY);

        return dMax;
    }


    //Normalize stuff

    //MyVector2
    public static PVector Normalize(PVector point, AABB2 boundingBox, float dMax)
    {
        float x = (point.x - boundingBox.minX) / dMax;
        float y = (point.y - boundingBox.minY) / dMax;

        PVector pNormalized = new PVector(x, y);

        return pNormalized;
    }

    //List<MyVector2>
    public static ArrayList<PVector> Normalize(ArrayList<PVector> points, AABB2 boundingBox, float dMax)
    {
        ArrayList<PVector> normalizedPoints = new ArrayList<PVector>();

        for (PVector p : points)
        {
            normalizedPoints.add(Normalize(p, boundingBox, dMax));
        }

        return normalizedPoints;
    }

    //UnNormalize different stuff

    //MyVector2
    public static PVector UnNormalize(PVector point, AABB2 boundingBox, float dMax)
    {
        float x = (point.x * dMax) + boundingBox.minX;
        float y = (point.y * dMax) + boundingBox.minY;

        PVector pUnNormalized = new PVector(x, y);

        return pUnNormalized;
    }

    //List<MyVector2>
    public static ArrayList<PVector> UnNormalize(ArrayList<PVector> normalized, AABB2 aabb, float dMax)
    {
        ArrayList<PVector> unNormalized = new ArrayList<PVector>();

        for (PVector p : normalized)
        {
            PVector pUnNormalized = UnNormalize(p, aabb, dMax);

            unNormalized.add(pUnNormalized);
        }

        return unNormalized;
    }
}

public static class MathUtility
{
  //Test if a float is the same as another float
  public static boolean AreFloatsEqual(float a, float b)
  {
      float diff = a - b;

      float e = EPSILON;

      if (diff < e && diff > -e)
      {
          return true;
      }
      else
      {
          return false;
      }
  }



  //Remap value from range 1 to range 2
  public static float Remap(float value, float r1_low, float r1_high, float r2_low, float r2_high)
  {
      float remappedValue = r2_low + (value - r1_low) * ((r2_high - r2_low) / (r1_high - r1_low));

      return remappedValue;
  }



  //Clamp list indices
  //Will even work if index is larger/smaller than listSize, so can loop multiple times
  public static int ClampListIndex(int index, int listSize)
  {
      index = ((index % listSize) + listSize) % listSize;

      return index;
  }



  // Returns the determinant of the 2x2 matrix defined as
  // | x1 x2 |
  // | y1 y2 |
  public static float Det2(float x1, float x2, float y1, float y2)
  {
      return (x1 * y2 - y1 * x2);
  }

  //Add value to average
  //http://www.bennadel.com/blog/1627-create-a-running-average-without-storing-individual-values.htm
  //count - how many values does the average consist of
  public static float AddValueToAverage(float oldAverage, float valueToAdd, float count)
  {
      float newAverage = ((oldAverage * count) + valueToAdd) / (count + 1f);

      return newAverage;
  }



  //Round a value to nearest int value determined by stepValue
  //So if stepValue is 5, we round 11 to 10 because we want to go in steps of 5
  //such as 0, 5, 10, 15
  public static int RoundValue(float value, float stepValue)
  {
      int roundedValue = (int)(round(value / stepValue) * stepValue);

      return roundedValue;
  }
}

enum BooleanOperation { Intersection, Difference, ExclusiveOr, Union }