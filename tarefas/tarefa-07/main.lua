-- Snake Game by Felipe Pestana
-- Utilize as setas para movimentar e esc para pausar

obstacle={}

function love.load()
    size= 20
    love.window.setMode(640, 480)
    countTime=0
    count=0
    isStartScreen=true
    score=0
end
 
function start ()
    isPause=false
    isAlive = true
    snake = {{x=16,y=12}}
    apple = {x=20,y=12}
    direction ={'stop'}
    obstacle={}
--Tarefa 07
--Coleção dinâmica de objetos
--O array obstacle é uma varíavel global que irá conter todos os objetos da coleção.
--Escopo:global, ou seja, pode ser acessado em qualquer parte do programa
--Tempo de vida:Essa varíavel está presente desde o início da primeira partida do jogo,
--e todos os seus objetos serão apagados a cada vez que for iniciado uma nova partida.
--Alocação: Quando a função start for executada no início do programa
--Desalocação:No encerramento do jogo

    score=0
    count=0
    countTime=0
    isStartScreen=false
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
--Tarefa 07
--Parte do código que checa se o jogador colidiu com algum objeto da coleção.
--Caso a função collides retorne positivo para algum elemento o jogo acaba.

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
--Tarefa 07
--Parte do código responsável pela remoção dos objetos da coleção.
--Cada objeto recebe um timer com valor inicial aleatório entre 1 e 20.
--Para cada maça coletada pelo jogador esse valor é decrescido em 1.
--Ao chegar a 0, o objeto é removido do array e do jogo.

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
--Tarefa 07
--Parte do código que chama a função responsável pela criação do objeto.
--A cada 3 maças coletadas pelo jogador essa função é chamada.

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
end

function createApple()
   local appleCoord=createCoord()
   apple={x=appleCoord[1],y=appleCoord[2]}
end

function createObstacle()
    local obstacleCoord=createCoord()
    local newTime=math.random(1,20)
    table.insert(obstacle,1,{x=obstacleCoord[1],y=obstacleCoord[2],time=newTime})
end
--Tarefa 07
--Objeto:Um elemento do array Obstacles
--Escopo:O escopo dos objetos também são globais, de acordo com a coleção a qual pertencem.
--Tempo de vida: Um novo objeto é criado a cada vez que o jogador come 3 maças, e cada um
--deles permanece no jogo até o seu campo "time" chegar a 0. 
--Alocação: Quando o jogador come uma quantidade de maças múltipla de 3.
--Desalocação: Cada obstáculo dura até o jogador conseguir comer uma quantidade de maças
--iguais ao seu valor de "time" inicial (definido aleatoriamente no momento de criação).

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
