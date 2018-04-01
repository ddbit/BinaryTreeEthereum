contract BTree{
    
        
    struct Node{
      uint x;
      uint lesser; //index to lesser
      uint greater;//index to greater
      bool    nil;
      uint parent;
    }
    Node [] public nodes;
    
    
    
    function nil() pure internal returns(Node){
        return Node({x:0,lesser:0, greater:0, nil:true, parent:0});
    }

    function BTree() public{
        nodes.push(nil());
    }

    function len() public view returns(uint){
        uint size=0;
        for (uint i=0;i<nodes.length;i++){
            if(!nodes[i].nil) size++;
        }
        return size;
    }

    function _push(uint x, uint nodeIdx) internal{
        Node storage tree = nodes[nodeIdx];
        if (tree.nil){
            tree.x = x;
            tree.nil=false;
            nodes.push(nil());
            tree.lesser = nodes.length - 1;
            nodes[tree.lesser].parent=nodeIdx;
            nodes.push(nil());
            tree.greater = nodes.length - 1;
            nodes[tree.greater].parent=nodeIdx;
        }
        else{
            if(x<=tree.x) _push(x, tree.lesser );
            if(x> tree.x) _push(x, tree.greater);
        }
    }
    
    function push(uint x) public{
        _push(x, 0);
    }
    
    
    function minIndex(uint startNode) public view returns(uint){
        Node storage tree=nodes[startNode];
        if (tree.nil) return 0;
        
        if(nodes[tree.lesser].nil) return startNode;
        
        return minIndex(tree.lesser);
        
    }
    
    function min() public view returns(uint){
        return nodes[minIndex(0)].x;
    }
    
    
    function remove(uint nodeIdx){
        Node node = nodes[nodeIdx];
        
        Node lesser = nodes[node.lesser];
        Node greater=nodes[node.greater];
        Node parent = nodes[node.parent];
        
        //case node has no children
        if(lesser.nil && greater.nil){
            //has no children
            //make node a nil node
            node.nil = true;
            node.x=0;
            node.lesser=0;
            node.greater=0;
            //keep parent
            //node.parent unchanged
        }
        
        //case node has exactly one child
        //and bypass reference to parent
        if(lesser.nil && !greater.nil){
            greater.parent = node.parent;
        }
        if(!lesser.nil && greater.nil){
            lesser.parent = node.parent;
        }
        
        //case node has both greater and lesser
        if(!lesser.nil && !greater.nil){
            //take the right min
            Node storage rightMin=nodes[minIndex(node.greater)];
            //replace this node content with rightMin
            node.x=rightMin.x;
            //remove the rightMin from tree -- recursive call
            remove(minIndex(node.greater));
   
        }
        
    }
    
    
    
}
