#! /bin/bash
HOMFA_RUNNER_DIR=../homfa-runner
TEST_RESULT_DIR=result

if [ $# -ne 3 ]; then
    echo "Input Error: Three Argumets are needed!"
    exit 1
fi

# 2番目の引数のが1以上の整数であることをチェック
if ! [[ $2 =~ ^[1-9][0-9]*$ ]]; then
    echo "Input Error: Second Argument Must Be Integer More Than 0."
    exit 1
fi

# 3番目の引数のプレフィックスが「input」であるかチェック
if [[ $3 != input* ]]; then
    set +x
    echo "Input Error: Third Argument Prefix Must Be Input!"
    exit 1
fi

CURRENT_DATE=$(date +%Y-%m-%d)
RESULT_FILE=${TEST_RESULT_DIR}/${1}/${CURRENT_DATE}_${1}_${2}_${3}
mkdir -p ${TEST_RESULT_DIR}/${1}



LTL_NAME=$1
AP=$2
INPUT_FILE=$3
MAIN_PATH=${HOMFA_RUNNER_DIR}/build/src/main 


execute_command() {
    local iterations=$1
    local command=$2

    for i in $(seq 1 $iterations); do
        { 
            echo $1 $2 $i
            set -x
            eval $command
            set +x
            draw_border
        } &>> $RESULT_FILE 
    done
}

draw_border() {
    echo -e "\n\n\n"
}

echo "$BASH $0 $1 $2 $3" > $RESULT_FILE

# 初回の動作が遅い場合があるので一度動かしておく
COMMAND="time $MAIN_PATH separate --type=reverse --top-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-top-type1.spec --bottom-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-bottom-type1.spec -p -i 300000"
eval $COMMAND

draw_border

COMMAND="$MAIN_PATH generate-key --input-file ${HOMFA_RUNNER_DIR}/input-files/${INPUT_FILE}"
execute_command 1 "$COMMAND"

echo separate block >> $RESULT_FILE
COMMAND="time $MAIN_PATH separate --type=block --top-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/forward-top.spec --bottom-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/forward-bottom.spec -p --block-size ${AP}"
execute_command 3 "$COMMAND"


echo torus-splitter block >> $RESULT_FILE
COMMAND="time $MAIN_PATH torus-splitter --type=block --graph-file ${HOMFA_RUNNER_DIR}/graph-config/three-dfa/${LTL_NAME}/forward.spec --block-size ${AP}"
execute_command 3 "$COMMAND"


echo separate reverse type1 bs300 >> $RESULT_FILE
COMMAND="time $MAIN_PATH separate --type=reverse --top-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-top-type1.spec --bottom-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-bottom-type1.spec -p -i 300"
execute_command 3 "$COMMAND"


echo separate reverse type1 bs300000 >> $RESULT_FILE
COMMAND="time $MAIN_PATH separate --type=reverse --top-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-top-type1.spec --bottom-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-bottom-type1.spec -p -i 300000"
execute_command 3 "$COMMAND"


echo torus-splitter reverse type1 bs300 >> $RESULT_FILE
COMMAND="time $MAIN_PATH torus-splitter --type=reverse --graph-file ${HOMFA_RUNNER_DIR}/graph-config/three-dfa/${LTL_NAME}/reverse-type1.spec -i 300"
execute_command 3 "$COMMAND"


echo torus-splitter reverse type1 bs300000 >> $RESULT_FILE
COMMAND="time $MAIN_PATH torus-splitter --type=reverse --graph-file ${HOMFA_RUNNER_DIR}/graph-config/three-dfa/${LTL_NAME}/reverse-type1.spec -i 300000"
execute_command 3 "$COMMAND"


echo separate reverse type2 bs300 >> $RESULT_FILE
COMMAND="time $MAIN_PATH separate --type=reverse --top-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-top-type2.spec --bottom-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-bottom-type2.spec -p -i 300"
execute_command 3 "$COMMAND"

echo separate reverse type2 bs300000 >> $RESULT_FILE
COMMAND="time $MAIN_PATH separate --type=reverse --top-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-top-type2.spec --bottom-file ${HOMFA_RUNNER_DIR}/graph-config/two-dfa/${LTL_NAME}/reverse-bottom-type2.spec -p -i 300000"
execute_command 3 "$COMMAND"


echo torus-splitter reverse type2 bs300 >> $RESULT_FILE
COMMAND="time $MAIN_PATH torus-splitter --type=reverse --graph-file ${HOMFA_RUNNER_DIR}/graph-config/three-dfa/${LTL_NAME}/reverse-type2.spec -i 300"
execute_command 3 "$COMMAND"


echo torus-splitter reverse type2 bs300000 >> $RESULT_FILE
COMMAND="time $MAIN_PATH torus-splitter --type=reverse --graph-file ${HOMFA_RUNNER_DIR}/graph-config/three-dfa/${LTL_NAME}/reverse-type2.spec -i 300000"
execute_command 3 "$COMMAND"


