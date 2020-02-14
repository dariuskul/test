using System;
using System.Collections.Generic;
using System.Text;

namespace HeapSort
{
    class Node
    {
       public float key;
       public Node left, right;

        public Node(float item)
        {
            key = item;
            left = right = null;
        }

        public Node()
        {
            
        }



    }


    class DataTree
    {
        public Node root;
        int count;

        public DataTree(float key)
        {
            root = new Node(key);
            count = 1;
        }

        public DataTree()
        {
            root = null;
            count = 0;
        }

        public Node insertNode(Node head, float data)
        {
            if (head == null)
            {
                head = new Node();
                head.key = data;
                return head;
            }

            if (head.key < data)
            {
                head.right = insertNode(head.right, data);
            }
            else
            {
                head.left = insertNode(head.left, data);
            }
            return head;

        }

        public void insert(float data)
        {
            count++;
            root = insertNode(root, data);
        }

        public void printTree(Node node)
        {
            if (node == null)
                return;
            else
            {
                Console.WriteLine(node.key);
                printTree(node.left);
                printTree(node.right);
            }


        }

        public int getCount()
        {
            return count;
        }



        public void print()
        {
            printTree(root);
        }


    }

    class HeapSort
    {
        
    }

      

}
