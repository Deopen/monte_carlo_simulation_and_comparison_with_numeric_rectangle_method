-- Simulation HW#1
-- Wrote by Omid Yaghoubi 
-- deopenmail@gmail.com
-- Made with Codea

-- Use this function to perform your initial setup
function setup()
    --displayMode(FULLSCREEN)
    myInit()
    maxPices=150 -- for numeric integral
    yScale=250
    numericRes={}
    randomRes={} -- for calcuating mean
    lastNumericRes=0
    fps=0
    lastMaxRandCount=0
    parameter.integer("maxRandCount",5,500)
    parameter.integer("maxPices",5,2300)
    parameter.action("Numeric",pauseNumeric)
    maxRandCount=70
    maxPices=700
    sizeOfRandomResForMean=1000
    pauseNumericFlag=false
    
    
end

function pauseNumeric()
    pauseNumericFlag=not pauseNumericFlag
end

function randomResAppend(element)
    randomRes[(#randomRes%sizeOfRandomResForMean )+1]=element
end

function resetRandMeanCalcuator()
    randomRes={}
end

function mainFunc(x)
    return math.sqrt(math.sin(x))
end

-- This function gets called once every frame
function draw()
    
    -- This sets a dark background color 
    if lastMaxRandCount~=maxRandCount then
        resetRandMeanCalcuator()
        lastMaxRandCount=maxRandCount
    end
    myDrawInit()
    xLimit=(math.pi/2)
    drawBorder(xLimit)
    --drawTheFunction(math.sin,xLimit,500,"sin")
    
    if not pauseNumericFlag then
        -- Numerical Integration Recatngle Method
        stroke(255, 0, 0, 255)
        pushStyle()    
        for i=1,maxPices do
            if numericRes[i]==nil then
                res=numericalIntegration(mainFunc,{x=0,y=xLimit},i)
                numericRes[i]=res
            else
                res=numericRes[i]
            end
            stroke(200,norm{curr={val=i,max=maxPices},norm={max=255}},0) -- Color
            normedX=norm { curr={val=i,max=maxPices},norm={max=500} }
            normedY=norm { curr={val=res,max=xLimit},norm={max=400} } 
            point(normedX,normedY,2)
            if i==maxPices then
                if i==maxPices then lastNumericRes=res end
                text
                ('y='..string.format(" %.3f",res)..
                ", Pices="..i,normedX,normedY+40)
            end --end if i==max ...
        end --end loop
        popStyle()
        -- End Numerical Integraion
    end -- end if nummeric pause is false
    
    -- Random Method Integration
    stroke(0, 48, 255, 255)
    pushStyle()
    lastPoint={}
    
    for randCount=1,maxRandCount do
        tmpSum=0
        for i=1,randCount do
            --print(norm{curr={val=math.random(),max=0.999},norm={max=xLimit}})-- Debug porpus
        -- Method 1================================================================= 
        --[[
            tmpSum=tmpSum+
            (mainFunc( norm{curr={val=math.random(),max=1},norm={max=xLimit}} ) 
            * (xLimit/randCount) )
        ]]--
        -- Method 2 ==========================================================================
            tmpSum=tmpSum+mainFunc( norm{curr={val=math.random(),max=1},norm={max=xLimit}} )  
        -- ===================================================================================
            
        end -- end i=1 loop
        stroke(100,norm{curr={val=randCount,max=maxRandCount},norm={max=255}}, 255)
        -- Method 1 ====
        --res=tmpSum
        --==============
        -- Method 2 =============
        mean=tmpSum/randCount
        res=xLimit*mean
        -- ======================
        
        
        normedX=norm{ curr={val=randCount,max=maxRandCount},norm={max=500} }
        normedY=norm{ curr={val=res,max=xLimit},norm={max=400} }
        
        point(normedX,normedY,1.5)
        line( (lastPoint.x or normedX),(lastPoint.y or normedY),normedX,normedY)
        lastPoint={x=normedX,y=normedY}
        

        if randCount==maxRandCount then
            randomResAppend(res)
            text("y="..string.format("%.3f",res)..", RandCount="..randCount,
                normedX,250)
        end
        
    end -- end randCount=10 loop
    -- End Random method Integration
    pushStyle()
    fill(10,200+norm { curr={val=#randomRes,max=55},norm={max=sizeOfRandomResForMean} })
    rndMean,rndSTD = getMeanAndSTD(randomRes)
    text(string.format('Random Result mean : %.3f',rndMean),40,-60)
    text(string.format('Random Result STD: %.3f',rndSTD),33,-90)
    normedY=norm{ curr={val=rndMean,max=xLimit},norm={max=400} }
    yScale = normedY/rndMean
    strokeWidth(1.5)
    stroke(255, 255, 255, 255)
    line(504,normedY-(rndSTD*yScale),504,normedY+(rndSTD*yScale))
    rect(500,normedY-4,8,8)
    fill(255,0,0)
    text("*",504,normedY-4)  
    popStyle()
    if not pauseNumericFlag then
    text(string.format('Numerical Result : %.3f',lastNumericRes),23,-115)
    end

end

function numericalIntegration(func,limit,countOfRectangles)
    
    local delta= (limit.y-limit.x) /countOfRectangles
    local sum=0
    for x=limit.x,limit.y,delta do
        -- Method 1 ===============
        --sum=sum+(func(x)*delta)
        -- ========================
        sum=sum+func(x)
    end
    local mean=sum/countOfRectangles
    return mean*(limit.y-limit.x)
    
end --end nummerical Integration 

