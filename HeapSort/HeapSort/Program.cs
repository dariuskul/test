using System;

namespace HeapSort
{
    class Program
    {
        static void Main(string[] args)
        {
            DataTree tree = new DataTree();

            Random r = new Random();
            float a;
            for (int i = 0; i < 10; i++)
            {
                a = (float)r.NextDouble();
                tree.insert(a);
            }

            tree.print();
        }
    }
}
