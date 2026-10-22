
# chat_supabase

## Features
- Register account with email and password(at least 6)
- Login with email and password
- Real time messaging with single channel 
- Show message bubbles with sender info and timestamp
- Typing indicator
- Profile information with seperate page and in front of message bubbles
- 

## Statemanagement
- riverpod

## Generating riverpod generated files
- make -f MakeFile watch [in terminal]

### SonarQube CLI
- sonar auth login
- sonar list issues --project MarMarLwin_chat
- sonar list issues --project MarMarLwin_chat> sonarqube_issues.json
### (still not work)
- sonar list issues --project MarMarLwin_chat --severities CRITICAL --format table 

## Refactoring pipeline

All pipeline code lives in [pipeline/](pipeline/). See
[pipeline/README.md](pipeline/README.md) for the architecture and how to run
it on any repository. Quick start for this repository:

```sh
pip install -r pipeline/requirements.txt
# Stage 3 reads GEMINI_API_KEY (or ANTHROPIC_API_KEY for --provider claude)
# from the environment or from ./.env; --provider claude-code needs no key

python3 -m pipeline run --repo . --no-refactor  # Stages 1-2, no LLM calls
python3 -m pipeline inspect --repo .            # review the prompts
python3 -m pipeline refactor --repo . --limit 1 # Stage 3 trial (3 API calls)
python3 -m pipeline refactor --repo .           # Stage 3, all issues
python3 -m pipeline refactor --repo . --provider claude-code  # Claude via your Pro plan
python3 -m pipeline refactor --repo . --provider claude       # Claude via API credits
```

Outputs are written to `pipeline/runs/chat/`. `refactor` also creates one
local git branch per strategy with the refactored code
(`refactor/<model>/zero-shot`, `few-shot`, `repository-aware`); commit your
work first, as the branches start from the current commit.


```sh 
python3 -m pipeline fetch-issues --repo .
python3 -m pipeline extract      --repo .
python3 -m pipeline index        --repo .   # again whenever the code changes
python3 -m pipeline prompts      --repo .
python3 -m pipeline inspect      --repo . --issue dart:S7115 --show repository_aware

python3 -m pipeline refactor --repo . --provider claude-code --strategy repository_aware


python3 -m pipeline refactor     --repo . --limit 1
```