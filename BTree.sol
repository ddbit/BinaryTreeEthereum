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
    
    
    
    
}
