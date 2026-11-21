# Open pull requests, 2026-11-21

31 open pull requests by @moezdil. Written every day by the daily-report workflow.

## Needs attention

- [Project-HAMi/HAMi-DRA#228](https://github.com/Project-HAMi/HAMi-DRA/pull/228) feat(amd): share compute between memory slices without a CU mask: CI failing (1)
- [Project-HAMi/HAMi-DRA#231](https://github.com/Project-HAMi/HAMi-DRA/pull/231) fix(security): delete only templates the webhook created on job deletion: CI failing (1)
- [Project-HAMi/HAMi-DRA#232](https://github.com/Project-HAMi/HAMi-DRA/pull/232) fix(webhook): do not convert a zero device count into a claim: CI failing (1)
- [Project-HAMi/HAMi-DRA#233](https://github.com/Project-HAMi/HAMi-DRA/pull/233) fix(monitor): do not count usage again when another slice of the node changes: CI failing (1)
- [Project-HAMi/HAMi-DRA#234](https://github.com/Project-HAMi/HAMi-DRA/pull/234) fix(monitor): scale core ratios by the device's core capacity: CI failing (1)
- [Project-HAMi/HAMi-DRA#235](https://github.com/Project-HAMi/HAMi-DRA/pull/235) fix(chart): publish type hcu in the fake Hygon profile: CI failing (1)
- [Project-HAMi/HAMi-DRA#236](https://github.com/Project-HAMi/HAMi-DRA/pull/236) fix(monitor): serve probes during the cache sync and bound it: CI failing (1)
- [Project-HAMi/HAMi-DRA#237](https://github.com/Project-HAMi/HAMi-DRA/pull/237) fix(webhook): reuse a claim left by a pod rejected after admission: CI failing (1)
- [Project-HAMi/HAMi-WebUI#333](https://github.com/Project-HAMi/HAMi-WebUI/pull/333) feat: add an AMD provider (draft): conflicts, no activity for 44 days
- [lfedgeai/SPEAR#102](https://github.com/lfedgeai/SPEAR/pull/102) ci: run checks on pull requests: no activity for 18 days
- [moezdil/siltide#191](https://github.com/moezdil/siltide/pull/191) Restrict downloads to HTTPS and bound the DaemonSet's ephemeral storage: CI failing (1)
- [vllm-project/vllm-omni#9598](https://github.com/vllm-project/vllm-omni/pull/9598) [Frontend] Import build_app and setup_server from vllm.entrypoints.launchers: changes requested

## All

| Pull request | Title | Open | Behind | Conflicts | CI | Review | Last activity |
|---|---|---|---|---|---|---|---|
| [Project-HAMi/HAMi-DRA#228](https://github.com/Project-HAMi/HAMi-DRA/pull/228) | feat(amd): share compute between memory slices without a CU mask | 4d | 0 | no | failing (1) | review required | 4d ago |
| [Project-HAMi/HAMi-DRA#229](https://github.com/Project-HAMi/HAMi-DRA/pull/229) | fix(security): bump go to 1.26.11 and golang images to 1.27.4 | 3d | 0 | no | pending (1) | review required | 3d ago |
| [Project-HAMi/HAMi-DRA#231](https://github.com/Project-HAMi/HAMi-DRA/pull/231) | fix(security): delete only templates the webhook created on job deletion | 2d | 0 | no | failing (1) | review required | 2d ago |
| [Project-HAMi/HAMi-DRA#232](https://github.com/Project-HAMi/HAMi-DRA/pull/232) | fix(webhook): do not convert a zero device count into a claim | 2d | 0 | no | failing (1) | review required | 2d ago |
| [Project-HAMi/HAMi-DRA#233](https://github.com/Project-HAMi/HAMi-DRA/pull/233) | fix(monitor): do not count usage again when another slice of the node changes | 2d | 0 | no | failing (1) | review required | 2d ago |
| [Project-HAMi/HAMi-DRA#234](https://github.com/Project-HAMi/HAMi-DRA/pull/234) | fix(monitor): scale core ratios by the device's core capacity | 2d | 0 | no | failing (1) | review required | 2d ago |
| [Project-HAMi/HAMi-DRA#235](https://github.com/Project-HAMi/HAMi-DRA/pull/235) | fix(chart): publish type hcu in the fake Hygon profile | 2d | 0 | no | failing (1) | review required | 2d ago |
| [Project-HAMi/HAMi-DRA#236](https://github.com/Project-HAMi/HAMi-DRA/pull/236) | fix(monitor): serve probes during the cache sync and bound it | 2d | 0 | no | failing (1) | review required | 2d ago |
| [Project-HAMi/HAMi-DRA#237](https://github.com/Project-HAMi/HAMi-DRA/pull/237) | fix(webhook): reuse a claim left by a pod rejected after admission | 2d | 0 | no | failing (1) | review required | 2d ago |
| [Project-HAMi/HAMi-DRA#238](https://github.com/Project-HAMi/HAMi-DRA/pull/238) | fix(volcano): convert Volcano tasks like pods | 2d | 0 | no | pending (1) | - | 2d ago |
| [Project-HAMi/HAMi-WebUI#333](https://github.com/Project-HAMi/HAMi-WebUI/pull/333) | feat: add an AMD provider (draft) | 44d | 55 | yes | pending (1) | review required | 44d ago |
| [Project-HAMi/HAMi#3467](https://github.com/Project-HAMi/HAMi/pull/3467) | feat(remotegpu): monitor Lupine servers | 4d | 17 | ? | pending (1) | review required | 3d ago |
| [Project-HAMi/HAMi#3468](https://github.com/Project-HAMi/HAMi/pull/3468) | feat(remotegpu): share Lupine servers and GPUs between pods | 4d | 17 | no | pending (1) | review required | 3d ago |
| [Project-HAMi/HAMi#3489](https://github.com/Project-HAMi/HAMi/pull/3489) | feat(googletpu): add Google TPU device backend (draft) | 2d | 5 | ? | pending (1) | review required | 1d ago |
| [Project-HAMi/HAMi#3491](https://github.com/Project-HAMi/HAMi/pull/3491) | fix(util): serve only the pod the node lock was taken for | 2d | 5 | ? | pending (1) | review required | 2d ago |
| [Project-HAMi/HAMi#3492](https://github.com/Project-HAMi/HAMi/pull/3492) | fix(nodelock): free an expired lock whose holder is not on the node | 2d | 5 | ? | pending (1) | review required | 2d ago |
| [Project-HAMi/HAMi#3493](https://github.com/Project-HAMi/HAMi/pull/3493) | fix(scheduler): guard scheduler-owned annotations on pods the webhook skips | 2d | 5 | no | pending (1) | review required | 2d ago |
| [Project-HAMi/HAMi#3494](https://github.com/Project-HAMi/HAMi/pull/3494) | test(e2e): check a pod annotation patch cannot reach a recreated pod | 2d | 5 | ? | pending (1) | review required | 2d ago |
| [agent-substrate/substrate#3882](https://github.com/agent-substrate/substrate/pull/3882) | MicroVM restores keep sparse files sparse | 4d | 63 | no | passing (5) | review required | 4d ago |
| [agent-substrate/substrate#3915](https://github.com/agent-substrate/substrate/pull/3915) | atelet: return Unavailable when Run or Restore fails to reset actor dirs | 4d | 62 | no | passing (5) | review required | 3d ago |
| [kagent-dev/kagent#3033](https://github.com/kagent-dev/kagent/pull/3033) | fix(translator): honor Harness command and args for Codex and Claude | 49d | 12 | no | passing (33) | review required | 4d ago |
| [kagent-dev/kagent#3702](https://github.com/kagent-dev/kagent/pull/3702) | fix(adk): send Ollama options with the types the server expects | 4d | 12 | no | passing (4) | review required | 4d ago |
| [kagent-dev/kagent#3704](https://github.com/kagent-dev/kagent/pull/3704) | fix(adk): stop putting the system prompt on the pod agent card | 4d | 12 | no | passing (5) | review required | 4d ago |
| [kagent-dev/kagent#3706](https://github.com/kagent-dev/kagent/pull/3706) | fix(adk): send non-streaming Anthropic requests with large max_tokens | 4d | 10 | no | passing (5) | review required | 4d ago |
| [kagent-dev/kagent#3725](https://github.com/kagent-dev/kagent/pull/3725) | fix(ui): keep every line of KAGENT_UI_EXTENSION_* values | 2d | 9 | no | passing (5) | review required | 2d ago |
| [lfedgeai/SPEAR#102](https://github.com/lfedgeai/SPEAR/pull/102) | ci: run checks on pull requests | 21d | 2 | no | passing (4) | - | 18d ago |
| [lfedgeai/SPEAR#98](https://github.com/lfedgeai/SPEAR/pull/98) | chore: clean up legacy leftovers, dead code and deprecated CI actions | 26d | 0 | no | none | - | 3d ago |
| [moezdil/siltide#191](https://github.com/moezdil/siltide/pull/191) | Restrict downloads to HTTPS and bound the DaemonSet's ephemeral storage | 12d | 0 | no | failing (1) | - | 12d ago |
| [vllm-project/vllm-omni#10540](https://github.com/vllm-project/vllm-omni/pull/10540) | [Bugfix] Validate profile_prefix like vLLM 0.33 | 4d | 178 | no | passing (7) | review required | 3d ago |
| [vllm-project/vllm-omni#9594](https://github.com/vllm-project/vllm-omni/pull/9594) | [Model] Replace deprecated torch sdp_kernel in CovoAudio token2wav | 22d | 0 | no | passing (7) | review required | 0d ago |
| [vllm-project/vllm-omni#9598](https://github.com/vllm-project/vllm-omni/pull/9598) | [Frontend] Import build_app and setup_server from vllm.entrypoints.launchers | 22d | 0 | no | passing (7) | changes requested | 0d ago |
