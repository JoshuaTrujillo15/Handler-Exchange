# Escrow Payment Distribution

This protocol proposal includes a way in which a contractor receives payment guarantees
with minimum risk of exploitation.

## Protocol Overview

---

**1:** Contractor creates a service offering

- The scope of the work
- Price of work
- Payment Distribution Method

**2:** Client purchases this service

- Details the work that needs to be done
- Client and Contrator reach a deal
- Client pays 100% upfront to an escrow account

**3:** Contractor starts work

- Depending on Payment Distribution Method,
payments could be a fixed rate,
or percentages based on project status (20% upfront, 80% upon completion).

**4a:** `IF` contractor OR client cancels at any time

- Contractor keeps funds already distributed to themself
- ALL funds still in escrow are refunded to the client

**4b:** Upon contract completion

- Any funds remaining in escrow are sent to the contractor
    - This should only happen in a fixed-rate-scenario,
    therefore, a contractor should not be punished for finishing
    the project early. 
- The contract closes

---

## Payment Distribution Method

The Payment Distribution Method consists of one of two options.

### 1: Fixed Rate

A fixed rate should include an estimation of the project's duration as well as a fixed rate of payment.
The client **MUST** still pay 100% upfront to an escrow account.
This is to protect the contractor from non-payment.
However, as stated in the protocol, if a contractor quits at any time before completion, all remaining funds in escrow are refunded to the client.
This is to protect the client from unnecessary loss.

### 2. Milestone Rate

A milestone rate essentially details a percentage that should be distributed at certain milestones in the project.
This allows the contractor to handle and expenses to themselves upfront.

An example structure may be as follows: 

    20% upfront,
    40% at MVP,
    final 20% at completion

## Escrow

Escrow, for clarity, functions as an account where the client deposits their coins at the project's start.
Whatever Payment Distribution Method and rate of distribution the contractor set on the contract is immutable, and is enforced programatically to ensure no exploitative behavior.

---