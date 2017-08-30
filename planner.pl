%% Helpers
%% Should succeed if all elements in Lists arg1 has are in List arg 2
subset([ ],_).
subset([H|T],List) :-
    member(H,List),		% If H in List, then inspect other elements of first argument List to other List by recalling
    subset(T,List).		% If not, then this basically fails because member failed

%% Returns a List containing path from X to Y
path1(X, Y, _,[X, Y]) :-
    road(X, Y, _).						% Direct path so put X and Y as [X,Y]
path1(X, Y, Visited, PathXY) :-
    road(X, C, _),						% Indirect path so C is intermediary city
	not(member(C, Visited)),			% C is not in Visited 
    path1(C, Y, [C|Visited], PathZY),	% There is a path from X to Y through C so remember this. Put C in Visited
    PathXY = [X | PathZY].				% Append X to path

%% Returns a List containing path from X to Y and total distance from X to Y
path2(X, Y, _, [X, Y], Z) :-
    road(X, Y, Z).									% Direct path so put X and Y as [X,Y]
path2(X, Y, Visited,PathXY, Length) :-
    road(X, C, Z),									% Indirect path so C is intermediary city
	not(member(C, Visited)),						% C is not in Visited 
    path2(C, Y, [C|Visited], PathZY, LengthZY),		% There is a path from X to Y through C so remember this including total length. Put C in Visited
    PathXY = [X | PathZY],							% Append X to path
    Length is Z + LengthZY.							% Remember total length of path 

%% Planner
%% Captures information of journeys in the format {From, To, Distance(km)} 
%% Assume connections are uniderectional i.e. A-->B is true, does NOT mean B-->A is true (see Reversed)
road(wellington,palmerstonNorth,143).
road(palmerstonNorth,wanganui,74).
road(palmerstonNorth,napier,178).
road(palmerstonNorth,taupo,259).
road(wanganui,taupo,231).
road(wanganui,newPlymouth,163).
road(wanganui,napier,252).
road(napier,taupo,147).
road(napier,gisborne,215).
road(newPlymouth,hamilton,242).
road(newPlymouth,taupo,289).
road(taupo,hamilton,153).
road(taupo,rotorua,82).
road(taupo,gisborne,334).
road(gisborne,rotorua,291).
road(rotorua,hamilton,109).
road(hamilton,auckland,126).

%% Reversed directions
road(palmerstonNorth,wellington,143).
road(wanganui,palmerstonNorth,74).
road(napier,palmerstonNorth,178).
road(taupo,palmerstonNorth,259).
road(taupo,wanganui,231).
road(newPlymouth,wanganui,163).
road(napier,wanganui,252).
road(taupo,napier,147).
road(gisborne,napier,215).
road(hamilton,newPlymouth,242).
road(taupo,newPlymouth,289).
road(hamilton,taupo,153).
road(rotorua,taupo,82).
road(gisborne,taupo,334).
road(rotorua,gisborne,291).
road(hamilton,rotorua,109).
road(auckland,hamilton,126).

%% Should succeed if there is a route from Start to Finish visiting the towns in list Visits	
route(Start, Finish, Visits) :-
	path1(Start, Finish, [], Path),		% Get a path from Start to Finish
	subset(Visits, Path).				% Succeed if all elements in Visits is in Path
	
%% Should succeed if there is a route from Start to Finish, visiting the towns in list Visits, which is Distance long
route(Start, Finish, Visits, Distance) :-
	path2(Start, Finish, [], Path, Length),			% Get a path from Start to Finish including total length
	subset(Visits, Path) , (Length == Distance).	% Succeed if all elements in Visits is in Path and Length of path == Distance

%% Should produce a list of all the routes (including their distances) between Start and Finish
choice(Start, Finish, RoutesAndDistances) :-
    findall(		% 'Concatenate' Path and Length [Path | Length] as a solution in RoutesAndDistances
		(Path, Length), 
		path2(Start, Finish, [], Path, Length),		% Get a path from Start to Finish including total length
		RoutesAndDistances
		).

%% Should produce a list of all the routes (including their distances) between Start and Finish which visit towns within Via
via(Start, Finish, Via, RoutesAndDistances) :-
	findall(		% 'Concatenate' Path and Length [Path | Length] as a solution in RoutesAndDistances
		(Path, Length),
			(path2(Start, Finish, [], Path, Length),	% Get a path from Start to Finish including total length
			subset(Via, Path)),							% Allow if all elements in Via is in Path
		RoutesAndDistances
		).

%% Should produce a list of all the routes (including their distances) between Start and Finish which do not visit towns within Avoiding
avoiding(Start, Finish, Avoiding, RoutesAndDistances) :-
	findall(		% 'Concatenate' Path and Length [Path | Length] as a solution in RoutesAndDistances
		(Path, Length),
			(path2(Start, Finish, [], Path, Length), 				% Get a path from Start to Finish including total length
			(member(E,Avoiding),member(E,Path) -> fail ; true)), 	% If Path and Avoiding has 1 or more element in both, then fail; else, continue
		RoutesAndDistances
		).

		
%% Testing -- should NOT give any warnings by interpreter
:-route(wellington,auckland,[napier],0) -> fail; true.	%% fail
:-route(wellington,palmerstonNorth,[taupo],707).	%% true
:-route(wellington,auckland,[],0) -> fail; true.	%% fail
:-route(wellington,palmerstonNorth,[],707).	%% true

:-choice(wellington,palmerstonNorth,R), length(R,83). %% true
:-choice(palmerstonNorth,wellington,R), length(R,83). %% true
:-choice(wellington,auckland,R), length(R,52). %% true
:-choice(auckland,wellington,R), length(R,52). %% true
:-choice(wellington,randon,R), length(R,0). %% true
:-choice(taupo,gisborne,R), length(R,602).	%% true

:-via(wellington,auckland,[rotorua],R), length(R,29). %% true
:-via(taupo,gisborne,[rotorua,newPlymouth],R), length(R,302).	%% true
:-via(taupo,gisborne,[],R), length(R,602).	%% true

:-avoiding(wellington,auckland,[rotorua],R), length(R,23).	%% true
:-avoiding(wellington,auckland,[auckland,rotorua],R), length(R,0).	%% true
:-avoiding(wellington,auckland,[wellington,rotorua],R), length(R,0).	%% true
:-avoiding(wellington,auckland,[],R), length(R,52).	%% true