%For runtime instantiated GameObject, only the prefab mapping is provided. Use that one substituting the gameobject name accordingly.
 %Sensors.

steeringLength(10000).
center(0,0).
steeringDir(1).

playerPosition(X,Y) :- playerSensor(player,objectIndex(Index),intPair(x(X))), playerSensor(player,objectIndex(Index),intPair(y(Y))).
playerVelocity(X,Y) :- playerSensor(player,objectIndex(Index),player(velocityX(X))), playerSensor(player,objectIndex(Index),player(velocityY(Y))).

target(X,Y) :- center(X,Y).

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
