-- Tarefa 04
-- Snake Game by Felipe Pestana
-- Utilize as setas para movimentar e esc para pausar


function love.load()
    size= 20
-- Nome: Variável “size”
-- Propriedade: Endereço
-- Binding time: Compile
-- Explicação: Por ser uma variável global, o espaço
-- e endereço dessa variável são alocados em tempo 
-- de compilação.

    love.window.setMode(640, 480)
    countTime=0
    isStartScreen=true
end
 
function love.keypressed (key)
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
 
function start ()
    isPause=false
    isAlive = true
    snake = {{x=16,y=12}}
    direction ={'stop'}
    createApple()
    score=0
    countTime=0
    isStartScreen=false
end
 
function createApple()
    local canCreate=false
-- Nome: Variável “canCreate”
-- Propriedade: Endereço
-- Binding time: Run
-- Explicação: Por ser uma variável local, o endereço
-- dessa variável só é alocado no tempo de execução
-- da função.

    while not canCreate do
        appleX=math.random(0,31)
        appleY=math.random(0,23)
        canCreate=true
        for i=1,#snake do
            if snake[i].x==appleX and snake[i].y==appleY then
                appleX=math.random(0,31)
                canCreate=false
                break
            end
        end
    end
    apple={x=appleX,y=appleY}
end
   
function collides (o1, o2)


    return (o1.x == o2.x) and (o1.y == o2.y)
end
 
function love.update (dt)
    countTime=countTime+ dt
-- Nome: Variável “countTime”
-- Propriedade: Valor
-- Binding time: Run
-- Explicação: O valor a ser atribuido a essa 
-- variável só é determinado no momento de 
-- execução da função.

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
-- Nome: Palavra “false”
-- Propriedade: Valor Booleano
-- Binding time: Design
-- Explicação: No tempo de design da linguagem foi 
-- definido que a palavra reservada "false" iria
-- representar o valor 0 (ou falso) de uma 
-- operação booleana.

            else
                table.insert(snake,1,{x=snake[1].x,y=newCoord})
            end
        end
        for i=2,#snake do
-- Nome: Palavra “for”
-- Propriedade: Semântica
-- Binding time: Design
-- Explicação: No tempo de design da linguagem foi 
-- definido que a palavra reservada "for" iria
-- representar uma estrutura de repetição.

            if collides(snake[1],snake[i]) then
                isAlive=false
            end
        end
        if collides(apple,snake[1]) then
            createApple()
            score=score+1
-- Nome: Operador “+”
-- Propriedade: Semântica
-- Binding time: Compile
-- Explicação: O funcionamento do operador '+'
-- é determinado em tempo de compilação do
-- código de acordo com os tipos dos termos
-- que estão sendo operados.

        elseif direction[1]~='stop' then
            table.remove(snake)
        end
	if #direction > 1 then
            table.remove(direction,1)
        end
    end
end
 
function love.draw ()
    if isStartScreen then
        love.graphics.setColor(255,0,0)
        love.graphics.setFont(love.graphics.newFont(50))
        love.graphics.printf("Snake Game",0,0,640,'center')
        love.graphics.setColor(255,255,255)
        love.graphics.setFont(love.graphics.newFont(25))
        love.graphics.printf("Space para comecar\nEsc para sair",150,100,640,'left')
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