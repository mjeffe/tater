# Reconcile

How to bring the running machine and the playbooks into agreement.

## Vocabulary

- audit: read-only comparison. Produce a report. Change nothing.
- apply: make the machine match a playbook. Never change the playbook.
- adopt: make a playbook match the machine. Never change the machine.

Run an audit before every apply or adopt. The audit is always safe.

## What to audit against

Each playbook has a Desired State section. That is authoritative. The
Current State section is a last-known snapshot and may be stale. Audit
against Desired State, not Current State.

## Workflow

1. Audit
   - Read every playbook and build the full list of Desired State facts.
   - Check each fact against the machine with read-only commands
     (dpkg-query, systemctl, df, findmnt, grep, cat).
   - Group the result by playbook and tag each fact:

       OK        the machine already matches
       MISSING   the playbook wants it, the machine lacks it
       EXTRA     the machine has it, no playbook declares it
       DIFFERENT both sides have it, but they disagree

   - Change nothing. Present the report to the human.

2. Decide
   - MISSING -> apply. This is the safe default direction.
   - EXTRA or DIFFERENT -> the human chooses apply or adopt.
   - An agent cannot read intent from state. Never auto-apply an
     EXTRA or DIFFERENT. Always ask.

3. Apply
   - Carry out the approved machine changes.
   - Flag any package install over 500MB (see AGENTS.md).
   - Re-run the audit after each change until it is clean.

4. Adopt
   - For approved adopt decisions, update the playbook's Desired State
     and Current State sections to match the machine.
   - Update the matching script under scripts/ if one exists.

5. Commit
   - Commit playbook and script changes together in one commit.
   - If a manual change was adopted, note it in the commit message.

## Idempotency

Every step is check-then-act: audit first, then change only what is not
already in the desired state. Running the full flow twice produces no
changes the second time.

## Scope

- Playbooks declare the top-level facts they own: packages, services,
  files, mounts, and config values.
- Do not try to account for every package dependency. Dependencies are
  noise.
- An EXTRA finding is only meaningful within a playbook's declared
  scope, plus obvious surprises like a new service or a new large
  package.
