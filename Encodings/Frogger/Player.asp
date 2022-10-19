%Versione Accorpata
%FattiNoti
firstStep(0).
secondStep(1).
xCoord(0..19).
maxXCoord(19).
maxZCoord(12).
zCoord(0..12).

setOnActuator(playerAct(player,objectIndex(X),player(answerA(V)))):- objectIndex(playerAct,X), Answer(V).

trunkRaw(X,Z,Dim):- trunkLine1(trunkSpawnerLine1,T,trunkSpawner(spawnedComponents(T1,trunk(posX(X))))),trunkLine1(trunkSpawnerLine1,T,trunkSpawner(spawnedComponents(T1,trunk(posZ(Z))))),trunkLine1(trunkSpawnerLine1,T,trunkSpawner(spawnedComponents(T1,trunk(dim(Dim))))).
trunkRaw(X,Z,Dim):- trunkLine2(trunkSpawnerLine2,T,trunkSpawner(spawnedComponents(T1,trunk(posX(X))))),trunkLine2(trunkSpawnerLine2,T,trunkSpawner(spawnedComponents(T1,trunk(posZ(Z))))),trunkLine2(trunkSpawnerLine2,T,trunkSpawner(spawnedComponents(T1,trunk(dim(Dim))))).
trunkRaw(X,Z,Dim):- trunkLine3(trunkSpawnerLine3,T,trunkSpawner(spawnedComponents(T1,trunk(posX(X))))),trunkLine3(trunkSpawnerLine3,T,trunkSpawner(spawnedComponents(T1,trunk(posZ(Z))))),trunkLine3(trunkSpawnerLine3,T,trunkSpawner(spawnedComponents(T1,trunk(dim(Dim))))).

trunk(X,Z):- trunkRaw(X,Z,1).
trunk(X,Z):- trunkRaw(X,Z,3).
trunk(X,Z):- trunkRaw(X1,Z,3),X=X1+1.
trunk(X,Z):- trunkRaw(X1,Z,3),X=X1-1.
trunk(X,Z):- trunkRaw(X,Z,5).
trunk(X,Z):- trunkRaw(X1,Z,5),X=X1+1.
trunk(X,Z):- trunkRaw(X1,Z,5),X=X1-1.
trunk(X,Z):- trunkRaw(X1,Z,5),X=X1+2.
trunk(X,Z):- trunkRaw(X1,Z,5),X=X1-2.

turtle(X,Z):- turtleLine1(tSpawnerLine1,T,turtleSpawner(spawnedComponents(T1,turtle(posX(X))))), turtleLine1(tSpawnerLine1,T,turtleSpawner(spawnedComponents(T1,turtle(posZ(Z))))).
turtle(X,Z):- turtleLine2(tSpawnerLine2,T,turtleSpawner(spawnedComponents(T1,turtle(posX(X))))), turtleLine2(tSpawnerLine2,T,turtleSpawner(spawnedComponents(T1,turtle(posZ(Z))))).

car(X,Z,Dir):- lineCars1(lineCars1,T1,scrollLine(carComponents(T,car(posX(X))))),lineCars1(lineCars1,T1,scrollLine(carComponents(T,car(posZ(Z))))),lineCars1(lineCars1,T1,scrollLine(dir(value(Dir)))),xCoord(X).
car(X,Z,Dir):- lineCars2(lineCars2,T1,scrollLine(carComponents(T,car(posX(X))))),lineCars2(lineCars2,T1,scrollLine(carComponents(T,car(posZ(Z))))),lineCars2(lineCars2,T1,scrollLine(dir(value(Dir)))),xCoord(X).
car(X,Z,Dir):- lineCars3(lineCars3,T1,scrollLine(carComponents(T,car(posX(X))))),lineCars3(lineCars3,T1,scrollLine(carComponents(T,car(posZ(Z))))),lineCars3(lineCars3,T1,scrollLine(dir(value(Dir)))),xCoord(X).
car(X,Z,Dir):- lineCars4(lineCars4,T1,scrollLine(carComponents(T,car(posX(X))))),lineCars4(lineCars4,T1,scrollLine(carComponents(T,car(posZ(Z))))),lineCars4(lineCars4,T1,scrollLine(dir(value(Dir)))),xCoord(X).
car(X,Z,Dir):- lineSuperCar(lineSuperCar,T1,scrollLine(carComponents(T,car(posX(X))))),lineSuperCar(lineSuperCar,T1,scrollLine(carComponents(T,car(posZ(Z))))),lineSuperCar(lineSuperCar,T1,scrollLine(dir(value(Dir)))),xCoord(X).

%Generazione posizioni Unsafe in base alle macchine
unsafe(X,Z):- car(X,Z,_).
unsafe(X,Z):- car(X1,Z,_), X=X1+1.
unsafe(X,Z):- car(X1,Z,_), X=X1-1.

%GOAL
goalRaw(X,Z,Avaible):- goal1(goal1,T,goal(posX(X))),goal1(goal1,T,goal(posZ(Z))),goal1(goal1,T,goal(empty(Avaible))).
goalRaw(X,Z,Avaible):- goal2(goal2,T,goal(posX(X))),goal2(goal2,T,goal(posZ(Z))),goal2(goal2,T,goal(empty(Avaible))).
goalRaw(X,Z,Avaible):- goal3(goal3,T,goal(posX(X))),goal3(goal3,T,goal(posZ(Z))),goal3(goal3,T,goal(empty(Avaible))).
goalRaw(X,Z,Avaible):- goal4(goal4,T,goal(posX(X))),goal4(goal4,T,goal(posZ(Z))),goal4(goal4,T,goal(empty(Avaible))).
goalRaw(X,Z,Avaible):- goal5(goal5,T,goal(posX(X))),goal5(goal5,T,goal(posZ(Z))),goal5(goal5,T,goal(empty(Avaible))).

goal(X,Z,Avaible):- goalRaw(X,Z,Avaible).
goal(X,Z,Avaible):- goalRaw(X1,Z,Avaible),X=X1+1.

%Posizione Player
playerPos(X,Z):- playerSensor(player,_,player(posX(X))),playerSensor(player,_,player(posZ(Z))).

%Generazione posizioni safe
safe(X,Z):- xCoord(X), Z=0. %RIGA SAFE
safe(X,Z):- xCoord(X), Z=6. %RIGA SAFE
safe(X,Z):- trunk(X,Z),xCoord(X).
safe(X,Z):- turtle(X,Z),xCoord(X).
safe(X,Z):- goal(X,Z,true),xCoord(X),Z=12.
safe(X,Z):- not unsafe(X,Z),xCoord(X),zCoord(Z),Z<6.

%Generazione Mosse
nextPlayerPos(X,Z,still):-playerPos(X,Z).
nextPlayerPos(X,Z1,up):-playerPos(X,Z), Z1=Z+1.
nextPlayerPos(X,Z1,down):-playerPos(X,Z),Z1=Z-1.
nextPlayerPos(X1,Z,left):-playerPos(X,Z), X1=X-1.
nextPlayerPos(X1,Z,right):-playerPos(X,Z), X1=X+1.

%StrongConstraints
:-Answer(M),nextPlayerPos(X,Z,M),not safe(X,Z).            %Non esiste risposta che porti ad una posizione non safe
:-Answer(left), playerPos(X,Z), car(X1,Z,1), X1<X.        %Non esiste mossa LEFT se mi trovo sulla stessa riga della macchina e questa si sta muovendo a destra
:-Answer(right), playerPos(X,Z), car(X1,Z,-1), X1>X.         %Non esiste mossa RIGHT se mi trovo sulla stessa riga della macchina e questa si sta muovendo a destra

:-Answer(M),nextPlayerPos(X,Z,M),maxXCoord(X).
:-Answer(M),nextPlayerPos(X,Z,M),X<1.


%WeakConstraints
%PRIORITA MASSIMA [N@4]
:~ Answer(M), nextPlayerPos(X,Z,M), playerPos(_,Z1), Z<Z1. [1@4] %Non preferire mosse che fanno retrocedere il player di posizione (downAvoid)


%PRIORITA ALTA [N@3]
:~ Answer(M), nextPlayerPos(X,Z,M), playerPos(X1,Z1), Z=Z1, X=X1. [1@3] % Non preferire mosse che non cambino la posizione del Player (stillAvoid)

%Regole che ho dovuto aggiungere per specificare che preferisco che la rana non usi la mossa left o right sui tronchi/tartarughe se non necessario.
:~ Answer(right),playerPos(X,Z),trunk(X,Z). [2@3]
:~ Answer(left),playerPos(X,Z),trunk(X,Z). [2@3]
:~ Answer(right),playerPos(X,Z),turtle(X,Z).[2@3]
:~ Answer(left),playerPos(X,Z),turtle(X,Z).[2@3]

%PRIORITA MEDIA [N@2]
:~ Answer(right),nextPlayerPos(X,Z,right),car(X1,Z1,1),Z1=Z+1. [1@2] %Non preferire la mossa destra se ti trovi sulla riga prima di quella delle macchine che si muovono da sinistra verso destra
:~ Answer(left),nextPlayerPos(X,Z,left),car(X1,Z1,-1),Z1=Z+1. [1@2]  %Non preferire la mossa sinistra se ti trovi sulla riga prima di quella delle macchine che si muovono da destra verso sinistra
:~ Answer(left). [1@2] %Dubbio destra o sinistra

%PRIORITA BASSA [N@1] - 
:~ Answer(down). [1@1] %Regole che ho dovuto aggiungere per specificare che preferisco che la rana prosegua.
:~ Answer(right). [1@1]


%GUESS
{Answer(M):nextPlayerPos(X,Z,M)}=1.

#show setOnActuator/1.