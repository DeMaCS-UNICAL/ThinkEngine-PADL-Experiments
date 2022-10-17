%For runtime instantiated GameObject, only the prefab mapping is provided. Use that one substituting the gameobject name accordingly.
 %Sensors.

steeringLength(10000).
steeringDir(-1).

playerPosition(X,Y) :- playerSensor(player,objectIndex(Index),intPair(x(X))), playerSensor(player,objectIndex(Index),intPair(y(Y))).
asteroidPosition(X,Y) :- asteroidSensor(asteroidClone,objectIndex(Index),intPair(x(X))), asteroidSensor(asteroidClone,objectIndex(Index),intPair(y(Y))).
%boundaryPosition(X,Y) :- boundarySensor012(boundary,objectIndex(Index),intPair(x(X))), boundarySensor012(boundary,objectIndex(Index),intPair(y(Y))).
%boundaryPosition(X,Y) :- boundarySensor01(boundary,objectIndex(Index),intPair(x(X))), boundarySensor01(boundary,objectIndex(Index),intPair(y(Y))).
%boundaryPosition(X,Y) :- boundarySensor0(boundary,objectIndex(Index),intPair(x(X))), boundarySensor0(boundary,objectIndex(Index),intPair(y(Y))).
%boundaryPosition(X,Y) :- boundarySensor(boundary,objectIndex(Index),intPair(x(X))), boundarySensor(boundary,objectIndex(Index),intPair(y(Y))).

playerVelocity(X,Y) :- playerSensor(player,objectIndex(Index),player(velocityX(X))), playerSensor(player,objectIndex(Index),player(velocityY(Y))).

distance(X2,Y2,D1,D2) :- playerPosition(X1,Y1), asteroidPosition(X2,Y2), D1=X1-X2, D2=Y1-Y2.
%distance(X2,Y2,D1,D2) :- playerPosition(X1,Y1), boundaryPosition(X2,Y2), D1=X1-X2, D2=Y1-Y2.
distance(X,Y,D) :- distance(X,Y,A,B), D1=A*A, D2=B*B, D=D1+D2.
target(X,Y) :- #min{K:distance(_,_,K)}=D, distance(X,Y,D).

desiredVelocity(X,Y) :- target(X1,Y1), playerPosition(X2,Y2), X=X1-X2, Y=Y1-Y2.  
steering(X,Y) :- desiredVelocity(X1,Y1), playerVelocity(X2,Y2), X=X1-X2, Y=Y1-Y2.

applyAction(0,"MoveAction").
actionArgument(0,"steeringX",X) :- applyAction(0,"MoveAction"), steering(X,_).
actionArgument(0,"steeringY",Y) :- applyAction(0,"MoveAction"), steering(_,Y).
actionArgument(0,"maxForce",K) :- applyAction(0,"MoveAction"), steeringLength(K).
actionArgument(0,"steeringDirection",K) :- applyAction(0,"MoveAction"), steeringDir(K).
%For ASP programs:
% Predicates for Action invokation.
% applyAction(OrderOfExecution,ActionClassName).
% actionArgument(ActionOrder,ArgumentName, ArgumentValue).
