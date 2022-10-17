maxTime(10).

player(X,Y,0):-playerSensor(ID,objectIndex(Index),intPair(x(X))),playerSensor(ID,objectIndex(Index),intPair(y(Y))).
missile(X_Left,X_Right,Y,S,0):-missileSensor(ID,objectIndex(Index),projectile(xLeft(X_Left))),missileSensor(ID,objectIndex(Index),projectile(xRight(X_Right))),missileSensor(ID,objectIndex(Index),intPair(y(Y))),missileSensor(ID,objectIndex(Index),projectile(increaseFactor(S))).

applyAction(0,"MoveAction").
applyAction(T_Next,"MoveAction") :- applyAction(T,"MoveAction"), T_Next=T+1, T<=T_Max, maxTime(T_Max).

direction("left") :- player(X,_,0), missile(X_Left,X_Right,_,_,0), L=X-X_Left, R=X_Right-X, L<R. 
direction("right") :- player(X,_,0), missile(X_Left,X_Right,_,_,0), L=X-X_Left, R=X_Right-X, R<=L. 

actionArgument(T,"move",D) :- applyAction(T,_), direction(D).
actionArgument(T,"move","left") :- applyAction(T,_), not direction("left"), not direction("right").
actionArgument(T,"emergency",true) :- applyAction(T,_).

#show applyAction/2.
#show actionArgument/3.

%#show player/3.
%#show missile/5.
%#show direction/1.
