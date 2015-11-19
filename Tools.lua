
function myInit()
--    showKeyboard()
end

function myDrawInit()
    strokeWidth(1)
    translate(WIDTH/10,HEIGHT/3.3)
end

function drawBorder(xLimit)
    pushStyle()
    background(29, 25, 35, 255)
    stroke(255, 255, 255, 255)
    noSmooth()
    line(0,0,500,0);text(xLimit,560,-10)
    line(0,0,0,500);
    popStyle()
end


function norm(args)
    -- miniMax normalization
    args.curr.min=args.curr.min or 0
    args.norm.min=args.norm.min or 0
    return args.norm.min+
    (
        args.norm.max* 
            ((args.curr.val-args.curr.min)/ (args.curr.max-args.curr.min )) 
                                                                             )
end -- end norm

function getMean(tbl)
    local sum=0
    for i=1,#tbl do sum=sum+tbl[i] end
    return sum/#tbl
end


function getSTD(tbl) 
    
    local mean=getMean(tbl)
    local res=0
    for i=1,#tbl do res=res+((tbl[i]-mean)^2) end
    res=res/#tbl
    
    return math.sqrt(res)
    
end

function getMeanAndSTD(tbl)
    local mean=getMean(tbl)
    local res=0
    for i=1,#tbl do res=res+((tbl[i]-mean)^2) end
    res=res/#tbl
    
    return mean,math.sqrt(res)
end

function point(x,y,width)
    pushStyle()
    strokeWidth( width or 2 )
    line(x,y,x,y)
    popStyle()
end


function keyboard(key)
    if tostring(key)=='q' or tostring(key)=='Q' then
        close()
    end
end
