
module Global{

    function min(a, b){
        if (a < b){
            return a;
        }else{
            return b;
        }
    }

    function max(a, b){
        if (a < b){
            return b;
        }else{
            return a;
        }
    }
    
    function mod(a){
        if (a > 0){
            return a;
        }else{
            return -a;
        }
    }
}