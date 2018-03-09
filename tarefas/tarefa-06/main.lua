-- Snake Game by Felipe Pestana
-- Utilize as setas para movimentar e esc para pausar

function love.load()
    size= 20
    love.window.setMode(640, 480)
    countTime=0
    count=0
    isStartScreen=true
end
 
function start ()
    isPause=false
    isAlive = true
    snake = {{x=16,y=12}}
    apple = {x=20,y=12}
--Tarefa-06
--Nome: snake
--Tipo: array
--Explicação: a variável snake define
--um conjunto infinito de valores homogêneos,
--identificados pelos seus índices. 

    direction ={'stop'}
    obstacle={}
    score=0
    count=0
    countTime=0
    isStartScreen=false
end

function love.keypressed (key)
--Tarefa-06
--Nome: key
--Tipo: Enum
--Explicação: a variável key só pode assumir 
--uma quantidade finita de valores enumerados
--que indicam as teclas que podem ser 
--pressionadas.

    if isStartScreen then
        if key == 'space' then
            start()
        elseif key == 'escape' then
            love.event.quit()
        end
    elseif isAlive and not isPause then
        if key == 'left' and direction[#direction]~='right' and direction[#direction]~='left' then
            table.insert(direction, 'left')
        elseif key == 'right' and direction[#direction]~='right' and direction[#direction]~='left' then
            table.insert(direction, 'right')
        elseif key == 'up' and direction[#direction]~='down' and direction[#direction]~='up' then
            table.insert(direction, 'up')
        elseif key == 'down' and direction[#direction]~='down' and direction[#direction]~='up' then
            table.insert(direction, 'down')
        elseif key == 'escape' then
            isPause = true
            direction ={'stop'}
        end
      elseif isPause then
        if key == 'escape' then
            love.event.quit()
        elseif key == 'space' then
            isPause=false
        end
    else
        if key == 'escape' then
            love.event.quit()
        elseif key == 'space' then
            start()
        end
    end
end
 


function collides (o1, o2)
    return (o1.x == o2.x) and (o1.y == o2.y)
end

function love.update (dt)
    countTime=countTime+ dt
    if isAlive and not isPause and countTime >= 0.13 then
        countTime = countTime - 0.13
        if direction[1]=='left' then
            newCoord=snake[1].x-1
            if newCoord<0 then
                isAlive=false
            else
                table.insert(snake,1,{x=newCoord,y=snake[1].y})
            end
        elseif direction[1]=='right' then
            newCoord=snake[1].x+1
            if newCoord>31 then
                isAlive=false
            else
                table.insert(snake,1,{x=newCoord,y=snake[1].y})
            end
        elseif direction[1]=='up' then
            newCoord=snake[1].y-1
            if newCoord<0 then
                isAlive=false
            else
                table.insert(snake,1,{x=snake[1].x,y=newCoord})
            end
        elseif direction[1]=='down' then
            newCoord=snake[1].y+1
            if newCoord>23 then
                isAlive=false
            else
                table.insert(snake,1,{x=snake[1].x,y=newCoord})
            end
        end
        for i=2,#snake do
            if collides(snake[1],snake[i]) then
                isAlive=false
            end
        end
	for i=1,#obstacle do
            if collides(snake[1],obstacle[i]) then
                isAlive=false
            end
        end
        if collides(apple,snake[1]) then
            createApple()
            score=score+1
   	    count=count+1
	    for i=#obstacle,1,-1 do
		obstacle[i].time=obstacle[i].time-1
                if obstacle[i].time==0 then
		    table.remove(obstacle,i)
		end
	    end
        elseif direction[1]~='stop' then
            table.remove(snake)
        end
	
	if #direction > 1 then
            table.remove(direction,1)
        end
	if count==3 then
            createObstacle()
            count=0
        end
    end
end
 
function createCoord()
    local canCreate=false
    local coord={}
    while not canCreate do
	coord={math.random(0,31),math.random(0,23)}
        canCreate=true
        for i=1,#snake do
            if snake[i].x==coord[1] and snake[i].y==coord[2] then
                canCreate=false
                break
            end
        end
        for i=1,#obstacle do
            if obstacle[i].x==coord[1] and obstacle[i].y==coord[2] then
                canCreate=false
                break
            end
        end
        if apple.x==coord[1] and apple.y==coord[2] then
	    canCreate=false
          break
	end
    end
    return coord
--Tarefa-06
--Nome: coord
--Tipo: tupla
--Explicação: a variável coord define um 
--conjunto de valores finitos que são 
--identificados pelos índices dos campos.

end

function createApple()
   local appleCoord=createCoord()
   apple={x=appleCoord[1],y=appleCoord[2]}
--Tarefa-06
--Nome: apple
--Tipo: registro
--Explicação: a variável apple define 
--um conjunto de valores finitos que são 
--identificados pelos nomes dos campos.

end

function createObstacle()
    local obstacleCoord=createCoord()
    local newTime=math.random(1,20)
    table.insert(obstacle,1,{x=obstacleCoord[1],y=obstacleCoord[2],time=newTime})
end

function love.draw ()
    if isStartScreen then
        love.graphics.setColor(255,0,0)
        love.graphics.setFont(love.graphics.newFont(50))
        love.graphics.printf("Snake Game",0,0,640,'center')
        love.graphics.setColor(255,255,255)
        love.graphics.setFont(love.graphics.newFont(25))
        love.graphics.printf("Space para comecar\nEsc para sair",150,100,640,'left')
	love.graphics.printf("Eat the apple to Score Points and Grow\nDodge the borders and the blue squares",80,200,640,'left')
	love.graphics.printf("Use the Arrow Keys to play\nEsc button to pause the game",120,300,640,'left')
    else
       
        love.graphics.setFont(love.graphics.newFont(15))
        love.graphics.setColor(255,255,255)
       	love.graphics.printf("Score: "..score,0,0,640,'left')
        if isAlive then
            love.graphics.setFont(love.graphics.newFont(30))
            love.graphics.setColor(0,255,0)
            for i=1,#snake do
                love.graphics.rectangle('fill', snake[i].x*size,snake[i].y*size, size,size)
            end
	    love.graphics.setColor(0,0,255)
            for i=1,#obstacle do
                love.graphics.rectangle('fill', obstacle[i].x*size,obstacle[i].y*size, size, size)
	    end
            love.graphics.setColor(255,0,0)
            love.graphics.rectangle('fill', apple.x*size,apple.y*size, size,size)
            if isPause then
                love.graphics.setColor(255,255,255)
                love.graphics.print("Pause\nSpace para continuar\nEsc para sair",150,100)
            end
        else
            love.graphics.setFont(love.graphics.newFont(40))
            love.graphics.setColor(255,255,255)
            love.graphics.printf("Game Over\n",0,0,640,'center')
            love.graphics.setFont(love.graphics.newFont(30))
            love.graphics.print("Space para jogar novamente\nEsc para sair",120,150)
        end
    end
end
