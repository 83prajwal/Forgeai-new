# ForgeAI exhibition demo script

## Before visitors arrive

1. Start ForgeAI and open <http://localhost:5000>.
2. For an offline expo or exhausted model quota, skip **System health**, turn **Demo replay** on, and use the task tracker prompt below. Replay runs from the local showcase catalog and needs no AI key or internet connection. When online, use **System health** only if you want to choose between replay and live generation.
3. Confirm the app can reach `/health`, that the counter loads, and that the preview area works. On Windows use `run.bat`; on Linux/macOS use `./run.sh`.
4. For the reliable 60-second version, turn **Demo replay** on and use the prompt below. The replay is intentionally labeled in the result.

## 60-second pitch for casual visitors

**Type this prompt:**

> A task tracker with task titles, due dates, priority levels, and a way to mark tasks complete.

**0:00–0:08 — Say:**

> “Most app ideas start as a sentence. ForgeAI turns that sentence into a working app, then checks that the app can actually save data.”

**0:08–0:15 — Action:** Turn **Demo replay** on, enter the prompt, and click **Generate app**.

**0:15–0:32 — Say while the pipeline runs:**

> “This is a prebuilt showcase replay, rather than a fresh AI generation. ForgeAI loads the task tracker from its local catalog, starts the Flask app, and checks its routes and database write. That makes the demo work when the model service or Wi-Fi is down.”

**0:32–0:46 — Action:** Open the preview, add “Exhibition follow-up” as a record, and show it appearing in the list. Point to the replay label and the verification status.

**0:46–1:00 — Say:**

> “The result is a real Flask and SQLite project. You can inspect the source, change the app, undo that change, or download the files. The replay makes the booth dependable; it is clearly distinguished from a fresh AI generation.”

## Three-minute walkthrough for technical judges

**Choose the path honestly:** For an offline demo, skip `/health`, enable replay, and identify it as a prebuilt showcase. If you want to demonstrate live generation, check `/health` first; do not present a replay as a new model-generated app.

**Fresh-generation prompt to type:**

> Build a campus club event signup app. Let visitors create an event with a title and date, let students register with their name and email, and show the attendee list for each event. Use SQLite and a simple responsive interface.

**Replay prompt if offline:**

> A student attendance app to record students, classes, attendance dates, and present or absent status.

### 0:00–0:25 — Problem and request

**Say:**

> “ForgeAI explores the gap between an idea and a runnable first version. I’ll use a small app request so you can see what the system actually produces. The health page tells us whether this will be a fresh model build or an offline replay.”

**Action:** Show `/health`, return to the main page, point out the demo toggle, and enter the appropriate prompt above.

### 0:25–1:10 — Pipeline and contract

**Say:**

> “The spec step creates entities and an API contract: methods, paths, request and response shapes, and database columns. That same contract is passed into code generation so the browser and Flask routes share an interface. Files are generated in dependency order; the entry-point boilerplate is deterministic.”

**Action:** Point to the stepper and build log. When source appears, show `routes.py` and `models.py`. In a replay, say: “These files are loaded from a checked local preset, rather than generated for this prompt.”

### 1:10–1:55 — Run and verification

**Say:**

> “ForgeAI starts the generated Flask process on a free local port. The verifier calls the contract’s GET endpoints, posts a sample record, reads it back, and confirms that it persisted in SQLite. A syntax check also catches invalid Python before the app is launched. If a check fails, a bounded repair step gets the failure details and the named file, then verification runs again.”

**Action:** Show the verification result and any repair summary. Open the live preview and submit one record. Avoid claiming that one verification run proves every possible behavior.

### 1:55–2:30 — Inspect and modify

**Say:**

> “The output is inspectable: generated source, the data blueprint, and a running preview. I can ask for one focused change, such as adding a search box. ForgeAI plans which files are affected, regenerates those files, verifies the app again, and keeps an earlier version available for undo.”

**Action:** If time and provider access allow, submit **Add search**. If not, point to the controls and explain that a replay is a fixed showcase, not a live modification demo. Do not imply modifications are supported on a replay unless they pass live verification.

### 2:30–3:00 — Tradeoffs and close

**Say:**

> “This is a local prototype, not a production app generator. Generated code runs with the local user’s permissions, so it is not sandboxed and should be reviewed before reuse. Model calls need a configured provider and may cost money. The verifier catches several important failures, but it cannot prove every security or product requirement. The goal is a testable starting point, with the limitations visible.”

**Action:** Show the download button, actual measured build time, and the health page. Finish with: “ForgeAI gets an idea to a checked first version; people still decide whether that version is safe and good enough to ship.”

## Recovery cues

- **Provider/network unavailable:** Turn on **Demo replay** and say, “This is a replay of a locally stored verified build.”
- **A fresh build fails:** Show the plain-English error. Retry once with a smaller prompt, or switch to the labeled replay.
- **Preview is blank:** Use **Refresh preview**. If it remains blank, return to the build log and use a different successful history item.
- **Queue is occupied:** Explain the queue position instead of starting duplicate builds.
