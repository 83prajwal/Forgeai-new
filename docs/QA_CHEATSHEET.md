# Judge Q&A cheat sheet

Answer what ForgeAI does today; label planned or untested behavior instead of presenting it as proven.

## 1. How is this different from asking ChatGPT to write the code?

ChatGPT can generate code in a conversation. ForgeAI adds an application pipeline around generation: a structured spec and API contract, ordered file generation, a Python syntax gate, process launch, endpoint and SQLite checks, bounded repair attempts, a live preview, history, and a downloadable project. The useful distinction is the run-and-check loop, not that the underlying model is unique.

## 2. What happens when the generated code is wrong?

Python files are parsed with `ast.parse` before they are written. After launch, the verifier exercises declared GET routes, creates a temporary record, confirms SQLite persistence, tests update/read-back/delete, and checks that deleted or untouched detail records are missing. Failures and app logs can go into a bounded self-repair loop, which targets the file named by the failure when possible. If verification still fails, the build is shown as failed; the verifier does not claim to catch every defect.

## 3. Does a passed verification mean the app is production-ready?

No. It means the tested startup, contract routes, and sample persistence checks passed. It does not establish security, correctness for every input, accessibility of every generated screen, load capacity, or deployment readiness. Generated code needs human review.

## 4. Is generated code sandboxed?

No. It runs as a local subprocess under the same operating-system account as ForgeAI. The app binds to localhost, has a time limit and concurrency cap, and its process is cleaned up on shutdown, but those controls are not an operating-system security sandbox. Do not generate or run untrusted code on a machine containing sensitive data.

## 5. Where are API keys stored? Are they shown in logs?

Provider keys are read from local environment configuration such as `.env`; `.env` is excluded from version control. The application should not print key values or key suffixes. Do not paste keys into prompts, screenshots, or a public repository. Check the repository and logs before publishing a build.

## 6. What does the LLM do, and what did the project team build?

Gemini or Groq supplies the natural-language spec and generated application files. The project team built the orchestration, prompts and file-generation flow, shared API contract, deterministic Flask entry point, syntax checks, process and port handling, verifier, repair workflow, preview proxy, history and download routes, offline replay path, and visitor-facing UI. Be specific about which parts each teammate implemented when presenting the project.

## 7. Which models and providers are supported?

ForgeAI tries Groq first and uses Gemini as a secondary provider for eligible provider failures. The active provider depends on local configuration, provider availability, and model access. `/health` reports provider reachability and the active-model information available to the application. The exact model and provider used for a particular build should be read from that build's logs when available.

## 8. Does it work without Wi-Fi?

The local UI, prepared showcase replays, preview proxy, and downloaded files work without model-provider access once ForgeAI and its Python dependencies are installed. A fresh model-generated app cannot be created offline. When provider endpoints are unreachable, ForgeAI uses a stored replay and labels it. First-time dependency installation may itself need package access, so install and verify before the exhibition.

## 9. What is the showcase replay? Is it generated live?

No. It is a local preset selected for a reliable demo. The six catalog entries use a small Flask + SQLite record-app runtime with different names, categories, and descriptions. They are rebuilt and checked at startup, and replay output is explicitly labeled. It demonstrates the local launch/preview/verification path, not fresh AI generation for the visitor's prompt.

## 10. What does the verifier actually test?

It waits for the app to respond, calls contract GET endpoints, creates one temporary record, confirms SQLite persistence, tests update/read-back/delete when those routes are declared, and checks missing detail records. It captures responses and app logs for repair. Coverage is contract-driven and intentionally limited; there are no comprehensive browser interaction or security tests.

## 11. How does self-repair work, and how many retries are allowed?

The repair step receives the verifier failure and relevant stderr/app logs, then targets the file associated with the failure when it can identify one. The retry count is bounded (up to three repair iterations in the pipeline). Repairs can introduce new mistakes, so ForgeAI verifies again and can still end in a failure state.

## 12. What does “without ForgeAI: ~2 days” mean?

It is an illustrative comparison, not a measured study or a universal coding-time claim. The ForgeAI time shown comes from the actual build duration. A fair comparison depends on app scope, a person's experience, and what “finished” means.

## 13. What does it cost to use?

ForgeAI itself is a local project, but model calls use the configured provider account and may be billable under that provider's current terms. ForgeAI does not currently estimate or cap token spend. Offline replay avoids model calls. The exhibition operator should check provider pricing and usage limits before enabling fresh generation.

## 14. Can it scale to many visitors or host production apps?

It is designed for one exhibition machine. Builds are queued and serialized, with an active-app cap and per-app lifetime. It has no distributed queue, multi-tenant isolation, production monitoring, or deployment hardening. Scaling would require a different process and security architecture.

## 15. How do modifications and undo work?

For a generated app, the modification planner selects a narrow set of affected files, passes the current files and contract as context, regenerates those files, then restarts and verifies the app. The previous files and spec are kept as a version for undo. The change can fail and be rolled back. Modifications require the model provider and should be demonstrated only when live verification succeeds; a replay is a fixed preset.
