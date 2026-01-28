[] allow auto-archy to create custom "archetypes" based on the project nature, which has extra "fine tuning / custom instructions" specific to the project, and allowing for flexible and adaptive state.json structure. This could possibly be done in a single step, during project initialization, where auto-archy checks for `*_archetype.py`, and if not present it creates one based on the project description.

[] if auto-archy can contain example archetype in its `auto-archy-protocol.md` along with the base prompt example.the `auto-archy-protocol.md` file it self should be generic as much as possible, eliminating the need to edit it per project, so it doesn't backlash on symlinked / hardlinked copies across other projects built by it.
So, the original auto-archy project has a single .md file that contains:
- the core philosophy and instructions of auto-archy
- example archetype
- example project_brief.md
- example state.json
- instructions to check for `*_archetype.py` and create one if not present.

[] Think of a way for `auto-archy` to reflect upon the project nature, and update the custom `*_archetype.py` accordingly. in an iterative process.

[] Weigh in the risks of allowing `auto-archy` to update itself in an iterative process, to benefit from the new experience learned from daughter projects, especially if the instructions `*_archetype.py` are good enough to be generalized and applied to other projects.