IN_GIT=0
REMOTE_ON=0
COMMITTED=0
BRANCH=""
REMOTE="origin"
IS_BR=0
BR_CHANGED=0
INDENT_LEVEL=2
INITBR=""

DUP=1
OPTION=""
CURBR=""
LASTBR=""

checkBranch()
{
if [[ $1 =~ ^@\#+ ]]; then
IS_BR=1; local arg=$1; local mk=#{arg:0:1}; local br=${arg:1}
local curbr=$(git rev-parse --abbrev-ref HEAD);

if [[ "$OPTION" == "" ]]; then #not an option
case "$mk" in;
  @)
    if [[ "br" == "done" ]]; then #@done

    else #@branch

    fi
  ;;
  \#)
    echo >&2 "unexpected repository: $br"
  ;;
esac
else #in an option
case "$mk" in;
  @)
    if [[ "br" == "done" ]]; then #@done

    else #@branch

    fi
  ;;
  \#)
  ;;
esac
fi

fi
}
# ############################
checkBranch()
{
if [[ $1 =~ ^@+ ]]; then 
  IS_BR=1
  local arg=$1
  local br=${arg:1}

  if [[ "$OPTION" == "" ]]; then
    if [[ "$DUP" == 0 ]]; then main; fi
    if [[ "$br" == "done" ]]; then
      if [[ "$BR_CHANGED" == 1 ]]; then
        git checkout $INITBR
        BR_CHANGED=0
      fi
      return
    else # @branch
      if [[ "$br" == "$LASTBR" ]]; then
        echo "Already on '$br'"
        return
      fi
      BR_CHANGED=1
      progress-bar "Checking local/$LASTBR" 0.005
      if [[ $(git branch --list $LASTBR | grep $LASTBR) ]]; then
        echo "local branch exists"
        git checkout $LASTBR
        main
      else
        echo "error: no local branch '$LASTBR'"
        exit 1;
      fi
      DUP=0
      LASTBR="$br"
    fi
  else
    if [[ "$br" == "done" ]]; then
      echo >&2 "illegal instruction: @done"
      exit 1
    else
      if [[ "$OPTION" == "f" ]]; then
        echo "working on pull action"
        # work
        OPTION=""
      fi
    fi
  fi
fi
}

# ################################################ 
checkBranch()
{
if [[ $1 =~ ^@+ ]]; then 
  IS_BR=1
  local arg=$1
  local br=${arg:1}

  if [[ "$OPTION" == "" ]]; then
    if [[ "$br" == "done" ]]; then
      # main will be operated after this.
      if [[ "$BR_CHANGED" == 1 ]]; then
        git checkout $INITBR
        BR_CHANGED=0
      fi
      return
    else
      if [[ "$LASTBR" == "" ]]; then #only in the beginning
        LASTBR="$br"
        return
      fi
      if [[ "$br" == "$LASTBR" ]]; then
        echo "Already on '$br'"
      else
        BR_CHANGED=1
        progress-bar "Checking local/$LASTBR" 0.005
        if [[ $(git branch --list $LASTBR | grep $LASTBR) ]]; then
          echo "local branch exists"
          git checkout $LASTBR
        else
          echo "error: no local branch '$LASTBR'"
          exit 1;
        fi
        LASTBR="$br"
      fi
    fi
  else
    if [[ "$br" == "done" ]]; then
      echo >&2 "illegal instruction: @done"
      exit 1
    else
      if [[ "$OPTION" == "f" ]]; then
        echo "working on pull action"
        # work
        OPTION=""
      fi
    fi
  fi
fi
}









#     ################################## OLD ##############


checkBranch()
{
if [[ $1 =~ ^@+ ]]; then 
  IS_BR=1
  local arg=$1
  local br=${arg:1}

  if [[ "$OPTION" == "" ]]; then
    if [[ "$br" == "done" ]]; then
      if [[ "$BR_CHANGED" == 1 ]]; then
        git checkout $INITBR
        BR_CHANGED=0
      fi
      return
    else
      if [[ "$br" == $(git rev-parse --abbrev-ref HEAD) ]]; then
        echo "Already on '$br'"
      else
        BR_CHANGED=1
        progress-bar "Checking local/$br" 0.005
        if [[ $(git branch --list $br | grep $br) ]]; then
          echo "local branch exists"
          git checkout $br
        else
          echo "error: no local branch '$br'"
          exit 1;
        fi
      fi
    fi
  else
    if [[ "$br" == "done" ]]; then
      echo >&2 "illegal instruction: @done"
      exit 1
    else
      if [[ "$OPTION" == "f" ]]; then
        echo "working on pull action"
        # work
        OPTION=""
      fi
    fi
  fi
fi
}