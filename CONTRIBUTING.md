# Learning together: Kien and Isaac

Use [ASIC Flow Practice](https://github.com/kienobrien/asic-flow-practice) as the ASIC 101 course hub and [RTL Practice](https://github.com/kienobrien/rtl-practice) for RTL exercises.

## Each lesson or lab
1. Open a lab issue using the template. Link the course lesson, agree on a goal, and choose a driver and reviewer.
2. Pull main before starting. Create a branch such as `kien/lab-01` or `isaac/lab-01`.
3. Commit the design, testbench, and your own notes together. Include exact commands, tool versions, expected and actual results, and a small waveform screenshot when useful.
4. Open a pull request with the template and link the issue. The other person reviews the behavior and explains one thing they learned.
5. Merge after the checks and review; update the session log with the outcome and next step. Swap driver and reviewer next session.

For pairing, share your screen and swap who types. For independent work, use separate branches and coordinate in the issue. Put decisions in the issue or notes so both people can catch up.

## What to preserve
- Your explanation of the hardware and why the design works.
- Failed approaches, the symptoms, and what fixed them.
- Reproducible commands and test results; distinguish measured results from predictions.
- Useful AI prompts and explanations, edited and checked by you. Store these in notes and link the relevant commit or PR.
- Questions you still cannot answer and a concrete next step.

Use `notes/session-log.md` for short session entries. Keep detailed lab notes in `notes/lab-NN.md`. Prefer small evidence files; generated build files are ignored.

These repositories are public. Share original notes and code; link to course materials rather than copying restricted course content. Keep credentials and private information out of commits.

## First-time collaborator setup
Kien adds Isaac's confirmed GitHub username under each repository's Settings > Collaborators. Isaac accepts the invitation and clones both repositories. Each person uses their own GitHub account.
