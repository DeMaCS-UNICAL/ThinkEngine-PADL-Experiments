% For ASP programs:
% Predicates for Action invokation.
% applyAction(OrderOfExecution,ActionClassName).
% actionArgument(ActionOrder,ArgumentName, ArgumentValue).


player(X,Y,0):-playerSensor(ID,objectIndex(Index),intPair(x(X))),playerSensor(ID,objectIndex(Index),intPair(y(Y))).
player_move_speed(X):-playerSensor(_,_,player(increaseFactor(X))).
laser(X,Y,S,0):-laserSensor(ID,objectIndex(Index),intPair(x(X))),laserSensor(ID,objectIndex(Index),intPair(y(Y))),laserSensor(ID,objectIndex(Index),projectile(increaseFactor(S))).

invaders(X,Y,0):-invader01Sensor(ID,objectIndex(Index),intPair(x(X))),invader01Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader02Sensor(ID,objectIndex(Index),intPair(x(X))),invader02Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader03Sensor(ID,objectIndex(Index),intPair(x(X))),invader03Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders_direction("right"):-invadersSensor(_,_,invaders(direction(x("1")))).
invaders_direction("left"):-invadersSensor(_,_,invaders(direction(x("-1")))).
invaders_move_speed(X,0):-invadersSensor(_,_,invaders(increaseFactor(X))).
invaders_move_speed(S_Next,T_Next) :- invaders_direction("right"), invaders_move_speed(S,T), S_Next=S+25, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
invaders_move_speed(S_Next,T_Next) :- invaders_direction("left"), invaders_move_speed(S,T), S_Next=S-25, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).


%bunkerSensor0(bunker,objectIndex(Index),).
%bunkerSensor0(bunker,objectIndex(Index),bunker(xRight(Value))).

bunker(X,Y):-bunkerSensor(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor(ID,objectIndex(Index),bunker(xRight(Y))).
bunker(X,Y):-bunkerSensor0(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor0(ID,objectIndex(Index),bunker(xRight(Y))).
bunker(X,Y):-bunkerSensor01(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor01(ID,objectIndex(Index),bunker(xRight(Y))).
bunker(X,Y):-bunkerSensor012(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor012(ID,objectIndex(Index),bunker(xRight(Y))).


% MAX PLAN LENGTH
maxTime(10).
min_x_matrix(-15500).
max_x_matrix(15500).
action("MoveAction").
move("left").
move("right").
action("FireAction").

% START PLANNING
1<={applyAction(0,A) : action(A)}<=1.
1<={actionArgument(0,"move",M) : move(M)}<=1 :- applyAction(0,"MoveAction").

%% PLANNED TIME STEP FOR T>0  
1<={applyAction(T_Next,A) : action(A)}<=1 :- applyAction(T,_), T_Next=T+1, T_Next<=TM, maxTime(TM).
1<={actionArgument(T,"move",M) : move(M)}<=1 :- applyAction(T,"MoveAction").

%% GET PLAYER PREVIOUS DIRECTION
previous_direction(D):-playerSensor(ID,objectIndex(Index),player(previousDirection(D))).

% ESTIMATE INVADERS' FUTURE POSITION 
invaders(X_Next,Y,T_Next) :- invaders(X,Y,T), T_Next=T+1, X>X_Min, X<X_Max, invaders_move_speed(S,T), X_Next=X+S, T_Next<=T_Max, maxTime(T_Max), min_x_matrix(X_Min), max_x_matrix(X_Max).

% ESTIMATE PLAYER'S FUTURE POSITION 
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","right"), player_move_speed(S), X_Next=X+S, X_Next<=X_Max, max_x_matrix(X_Max), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","left"), player_move_speed(S), X_Next=X-S, X_Next>=X_Min, min_x_matrix(X_Min), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X,Y,T_Next) :- player(X,Y,T), applyAction(T,"FireAction"), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

%player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"FireAction"), player_move_speed(S), X_Next=X+S, X_Next<=X_Max, max_x_matrix(X_Max), actionArgument(T_Prev,"move", "right"), T_Prev=T-1, T_Prev>=0, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
%player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"FireAction"), player_move_speed(S), X_Next=X-S, X_Next>=X_Min, min_x_matrix(X_Min), actionArgument(T_Prev,"move", "left"), T_Prev=T-1, T_Prev>=0, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

actionArgument(T,"xNext",X_Next) :- player(X_Next,_,T), not applyAction(T,"FireAction").

% ESTIMATE LASER'S FUTURE POSITION 
laser(X,Y_Next,S,T_Next) :- laser(X,Y,S,T), Y_Next=Y+S, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
% CREATE A NEW LASER AT TIME T IF YOU FIRE AT TIME T. LASER POSITION START AT PLAYER POSITION
laser(X,Y,200,T):-player(X,Y,T), applyAction(T,"FireAction").

% FIND ALL ENEMIES ON THE MOST LEFT/RIGHT COLUMN 
most_left_invader(X,T) :- #min{C: invaders(C,_,T)}=X, invaders(_,_,T).
most_right_invader(X,T) :- #max{C: invaders(C,_,T)}=X, invaders(_,_,T).

% FIND THE NEAREST W.R.T. TO THE PLAYER (ON X AND Y COORD)
min_y_invader(Y,T) :- #min{C: invaders(_,C,T)}=Y, invaders(_,_,T).
nearest_y_invader(X,Y,T) :- #min{C: invaders(C,Y,T)}=X, min_y_invader(Y,T).
invaders_near_player(T) :- invaders(_,Y1,T), player(_,Y2,T), Y1>=Y2, Y1-Y2<=12000.

% DO NOT FIRE IF THERE IS ALREADY AN ACTIVE LASER 
:-applyAction(T_Next,"FireAction"), laser(_,_,_,T), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
:-applyAction(T1,"FireAction"), applyAction(T2,"FireAction"), T2>T1+1.

% STRATEGIA DI MOVIMENTO
% NON ANDARE IN PUNTI ESTREMI (DESTRA/SINISTRA) DOVE NON CI SONO INVADERS
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","left"), player(X1,Y1,T), most_left_invader(X2,T), X1<=X2+100, T_Next=T+1.
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","right"), player(X1,_,T), most_right_invader(X2,T), X1>=X2-100, T_Next=T+1.



%%%%%%%%%%% WEAK CONSTRAINTS %%%%%%%%%%%

%%%%%%%%%%% UPDATE STRATEGY DEPENDING ON INVADERS HEIGHT %%%%%%%%%%%
% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù A SINISTRA (AD INIZIO GIOCO)
distance_left_column(X,T) :- not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X1-X2, X1>=X2.
distance_left_column(X,T) :- not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X2-X1, X1<X2.
:~distance_left_column(X,T). [X@4,T]

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù BASSE QUANDO GLI INVADERS SONO VICINISSIMI AL PLAYER (IN ALTEZZA)
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X1-X2, X1>=X2.
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X2-X1, X1<X2.
:~distance_player_invader(X,T). [X@4,X,T]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% WHEN MOVE, PREFER THE SAME DIRECTION OF PREVIOUS ACTIONS (AVOID LEFT AND RIGHT CONTINUOUS MOVE) 
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T2=T1+1, M1!=M2. [1@5,T1,M1,T2,M2]
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T1=T2+1, M1!=M2. [1@5,T1,M1,T2,M2]
:~actionArgument(T1,"move",M1), previous_direction(M2), M1!=M2. [1@4,M1,M2,T1]

% WHEN MOVE, GO TOWARDS INVADERS
:~actionArgument(_,"move",M), invaders_direction(M). [1@3,M]

% AUMENTA LA FREQUENZA DI FUOCO QUANDO GLI INVADERS SONO VICINI AL PLAYER
%:~applyAction(T, "MoveAction"), invaders_near_player(T). [10@6,T]


% ATTACK
% FIRE WHEN THERE IS AN INVADER UP TO THE PLAYER AND THERE IS NOT A BUNKER
:~applyAction(T_Next,"MoveAction"), nearest_y_invader(X,_,T_Next), player(X,_,T), player_under_bunker(T_Next), T_Next=T+1. [1@6,X,T]
:~applyAction(T_Next,"MoveAction"), invaders_near_player(T_Next), nearest_y_invader(X1,_,T_Next), player(X2,_,T), player_under_bunker(T_Next), T_Next=T+1. [1@6,T,X1,X2]

% DEFEND
player_under_bunker(T) :- player(X,Y,T), bunker(X_Left,X_Right), X>=X_Left, X<=X_Right.

% DO NOT FIRE TO BUNKER WHEN AT BEGINNING OF THE GAME. IF INVADERS ARE NEAR TO THE PLAYER IGNORE THIS WEAK
:~applyAction(T_Next,"FireAction"), player(X,_,T), not invaders_near_player(T_Next), bunker(X_Left,X_Right), X>=X_Left, X<=X_Right, T_Next=T+1. [1@4,X,T,X_Left,X_Right,T_Next]
:~applyAction(T,"FireAction"), player(X,_,T), not invaders_near_player(T), bunker(X_Left,X_Right), X>=X_Left, X<=X_Right. [1@4,X,T,X_Left,X_Right]

% DO NOT FIRE IF NO INVADERS ARE ON YOUR SAME COLUMN
%no_invaders_in_columns(X,T) :- #count{Y: invaders(X,Y,T)}=0, player(X,_,T).
%:~applyAction(T_Next,"FireAction"), player(X,_,T), no_invaders_in_columns(X,T), T_Next=T+1. [1@6,T_Next,X,T]

a.
:~a. [1@1]
:~a. [1@2]
:~a. [1@3]
:~a. [1@4]
:~a. [1@5]
:~a. [1@6]
:~a. [1@7]
:~a. [1@8]

#show applyAction/2. 
#show actionArgument/3.
#show player/3.
#show player_move_speed/1.

%#show invaders_direction/1.
%#show previous_direction/1.
%#show distance_right_column/2.
%#show distance_left_column/2.
%#show nearest_y_invader/3.
%#show invaders/3.
%#show distance_player_invader/2.
%#show min_y_invader/2.
%#show invaders_move_speed/1.
%#show laser/4.
%#show player_under_bunker/1.
%#show player/3.
%#show invadersSensor/3.
%#show bunker/2.
%#show nearest_y_invader/3.
%#show invaders_near_player/1.
%#show no_invaders_in_columns/2.

% STRATEGY:
% 1. DISTRUGGI PRIMA I NEMICI PER COLONNE PARTENDO DALLA SINISTRA --> SE LE COLONNE DIMINUISCONO, CI 
    % VOGLIONO PIù STEP PRIMA CHE POSSANO SCENDERE DI LIVELLO
% 2. DISTRUGGI I NEMICI SULLE RIGHE PIù IN BASSO
% 3. NON SPARARE SE SEI SOTTO UN BUNKER
% 4. NON SPARARE SE NON CI SONO NEMICI SOPRA DI TE (NON SPARARE A VUOTO)
% 5. SE TI TROVI SOTTO UN NEMICO è PREFERIBILE SPARARE 
% 6. QUANDO TI SPOSTI, CERCA DI SPOSTARTI VERSO I NEMICI DELLE FILE PIù IN BASSO O VERSO LE PRIME COLONNE

% SE IL NEMICO SI TROVA A 5 CELLE Y DA TE, è PREFERIBILE SPARARE A QUELLI PIù VICINI

% PROBLEMI DURANTE LA PIANIFICAZIONE PERCHè IL QUANDO CALCOLO LE FUTURE POSIZIONI DEL PLAYER CON LA CONVERSIONE DA FLOAT A INT
% HO GRAVI PERDITE: PER ME OGNI VOLTA CHE MI MUOVO MI TROVO IN UN POSIZIONE X_NEXT=X+1, NEL GIOCO CI SI SPOSTA DI +1 OGNI ~31 MOVE NELLA STESSA DIREZIONE!!!
