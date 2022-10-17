%For runtime instantiated GameObject, only the prefab mapping is provided. Use that one substituting the gameobject name accordingly.
 %Sensors.
playerPosition(X,Y) :- playerSensor(player,objectIndex(Index),intPair(x(X))), playerSensor(player,objectIndex(Index),intPair(y(Y))).
asteroidPosition(X,Y) :- asteroidSensor(asteroidClone,objectIndex(Index),intPair(x(X))), asteroidSensor(asteroidClone,objectIndex(Index),intPair(y(Y))).

distance(X2,Y2,D1,D2) :- playerPosition(X1,Y1), asteroidPosition(X2,Y2), D1=X1-X2, D2=Y1-Y2.
distance(X,Y,D) :- distance(X,Y,A,B), D1=A*A, D2=B*B, D=D1+D2.
target(X,Y) :- #min{K:distance(_,_,K)}=D, distance(X,Y,D).

desiredPath(X,Y) :- target(X1,Y1), playerPosition(X2,Y2), X=X1-X2, Y=Y1-Y2.


applyAction(0,"FireAction").
actionArgument(0,"desiredPathX",X) :- applyAction(0,"FireAction"), desiredPath(X,_).
actionArgument(0,"desiredPathY",Y) :- applyAction(0,"FireAction"), desiredPath(_,Y).
actionArgument(0,"targetX",X) :- applyAction(0,"FireAction"), target(X,_).

%For ASP programs:
% Predicates for Action invokation.
% applyAction(OrderOfExecution,ActionClassName).
% actionArgument(ActionOrder,ArgumentName, ArgumentValue).
