@games = qx(ls -d */);
open(SENS,">","sensorsPerPlanner.csv");
print SENS "ENCODING;ITERATION;SENSORS_NUMBER\n";
for $game (@games){
    chomp $game;
    @planners = qx(ls $game);
    for $planner (@planners){
        chomp $planner;
        $iteration=0;
        open(F,"<","./$game/$planner/shot.txt") || die $!;
        while (<F>){
            if(/shot.txt/){
                next;
            }
            if(/([^\s]*.txt)/){
                $iteration++;
                open(F1,"<","./$game/$planner/$1") || die $!;
                $cont=0;
                while (<F1>){
                    $cont++;
                }
                close(F1);
                print SENS substr($game,0,-1)."_".$planner.";".$iteration.";".$cont."\n";
            }
        }
        close(F);
    }
}
close(SENS);
