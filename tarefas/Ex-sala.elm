import Html exposing (text)

-- Considere uma turma de 50 alunos.
-- Cada aluno possui duas notas.
-- O aluno que ficou com média maior ou igual a sete é considerado aprovado.

-- Considere as seguintes definições em Elm para os tipos Aluno e Turma:

type alias Aluno = (String, Float, Float) -- Aluno é um tipo tupla com o nome e as duas notas
type alias Turma = List Aluno             -- Turma é um tipo lista de alunos

-- O nome ou a média de um aluno pode ser obtido através das seguintes funções:

media: Aluno -> Float
media (_,n1,n2) = (n1+n2)/2     -- o nome é ignorado

nome: Aluno -> String
nome (nm,_,_) = nm              -- as notas são ignoradas

-- Por fim, considere as assinaturas para as funções map, filter, e fold a seguir:

--List.map: (a->b) -> (List a) -> (List b)
  -- mapeia uma lista de a's para uma lista de b's com uma função de a para b

--List.filter: (a->Bool) -> (List a) -> (List a)
  -- filtra uma lista de a's para uma nova lista de a's com uma função de a para Bool

--List.foldl : (a->b->b) -> b -> List a -> b
  -- reduz uma lista de a's para um valor do tipo b
        -- usa um valor inicial do tipo b
        -- usa uma função de acumulacao que
            -- recebe um elemento da lista de a
            -- recebe o atual valor acumulado
            -- retorna um novo valor acumulado

-- Usando as definições acima, forneça a implementação para os três trechos marcados com <...>:

turma: Turma
turma = [ ("Joao",7,4), ("Maria",10,8) ]       -- 50 alunos

-- a) LISTA COM AS MÉDIAS DOS ALUNOS DE "turma" ([5.5, 9, ...])
medias: List Float
medias = List.map media turma 

-- b) LISTA COM OS NOMES DOS ALUNOS DE "turma" APROVADOS (["Maria", ...])
aprova: Aluno -> Bool
aprova (_,x,y)=((x+y)/2)>=7.0

aprovados: List String
aprovados = List.map nome (List.filter aprova turma)

-- c) MÉDIA FINAL DOS ALUNOS DE "turma" (média de todas as médias)
mediaT: Float -> Float -> Float
mediaT x y = x+y

count: Aluno -> Float -> Float
count x y = y+1.0

total: Float
total = (List.foldl mediaT 0 medias)/(List.foldl count 0 turma)

-- d) LISTA DE ALUNOS QUE GABARITARAM A P1 ([("Maria",10,8), ...])
dez_p1: Aluno -> Bool
dez_p1 (_,x,_) = (x==10)

turma_dez_p1: Turma
turma_dez_p1 = List.filter dez_p1 turma

-- e) LISTA COM OS NOMES E MEDIAS DOS ALUNOS APROVADOS ([("Maria",9), ...])
nome_media: Aluno -> (String,Float)
nome_media(nome,n1,n2) = (nome,(n1+n2)/2)

aprovados2: List (String,Float)
aprovados2 = List.map nome_media (List.filter aprova turma) 

-- f) LISTA COM TODAS AS NOTAS DE TODAS AS PROVAS ([7,4,10,8,...])
nota: Aluno -> List Float -> List Float
nota (_,n1,n2) x = n1 :: (n2 :: x)

notas: List Float
notas = List.foldr nota [] turma

-- É permitido usar funções auxiliares, mas não é necessário.
-- (As soluções são pequenas.)

main = text (toString turma)
