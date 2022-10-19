open(F,"<","./shot.txt") || die $!;
open(F1,">","template.xml") || die $!;
print F1 "<load path=\"problems/Frogger/Planner.asp\" background=\"true\"/>\n";
while (<F>){
    if(/shot.txt/){
        next;
    }
    if(/([^\s]*.txt)/){
        print F1 "<load path=\"problems/Frogger/$1\"/>\n <run/>\n";
    }
}
print F1 "<reset/>\n <exit/>\n";
close(F);
close(F1);