using System;

namespace ReadFromFile
{
    class Node
    {
        int key;
        Node left;
        Node right;

        public Node()
        {
            left = null;
            right = null;
            key = -1;
        }

        Node newNode()
        {
            Node temp = new Node();
            temp.key = key;
            temp.right = temp.left = null;
            return temp;
        }


        
    }

    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
