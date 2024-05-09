echo Game start...
echo You will recieve a set of multiple choice questions and your score will be displayed afterwards
echo to check you score enter 0
# read -p "press Enter key to continue" filler

# shuffle the questions
numbers=($(seq 1 1 10))
numbers=( $(shuf -e "${numbers[@]}") )
# printf "%d\n" "${numbers[@]}" # uncomment this line to display the order of the questions
score=0 #keep track of the score. each wrong answre deduces 1 point
for number in "${numbers[@]}"
do
    echo
    awk "NR==${number}" questions.txt
    choicesLine=$((2*number))
    pointsLine=$((2*number-1))
    points=$(cat answers.txt | sed -n ${pointsLine}p)
    answer=0
    counter=0
    for i in $(head -n ${choicesLine} answers.txt | tail -n -1 | tr " " "_" |tr "," "\n")
    do
        counter=$((counter+1));
        if [ ${i:0-1} = ";" ]
        then
            answer=$((counter))
        fi
    done

    head -n ${choicesLine} answers.txt | tail -n -1 | tr "," "\n" | tr -d ";"

    read choice
    while [ $choice != $answer ]
    do
        if [ "$choice" -ge 1 ] && [ "$choice" -le 4 ]
        then
            echo "try again"
            score=$((score-1))
        elif [ "$choice" = 0 ]
        then
            echo "score: ${score}"
        else    
            echo "invalid input"
        fi
    read choice
    done
    echo "correct"
    score=$((score+points))
done
echo "score: $score"