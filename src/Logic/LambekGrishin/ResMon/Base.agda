------------------------------------------------------------------------
-- The Lambek Calculus in Agda
--
------------------------------------------------------------------------


open import Function using (_∘_)
open import Data.Product using (∃; _,_)
open import Relation.Nullary using (Dec; yes; no)
open import Relation.Nullary.Decidable using (True; toWitness; fromWitness)
open import Relation.Binary.HeterogeneousEquality as H using (_≅_)


module Logic.LambekGrishin.ResMon.Base {ℓ} (Univ : Set ℓ) where


open import Logic.Type Univ
open import Logic.Judgement Type Type


infix 3 LG_

data LG_ : Judgement → Set ℓ where

  id     : ∀ {A}       → LG el A ⊢ el A

  -- rules for residuation and monotonicity
  mon-⊗  : ∀ {A B C D} → LG A ⊢ B → LG C ⊢ D → LG A ⊗ C ⊢ B ⊗ D
  mon-⇒  : ∀ {A B C D} → LG A ⊢ B → LG C ⊢ D → LG B ⇒ C ⊢ A ⇒ D
  mon-⇐  : ∀ {A B C D} → LG A ⊢ B → LG C ⊢ D → LG A ⇐ D ⊢ B ⇐ C
  res-⇒⊗ : ∀ {A B C}   → LG B ⊢ A ⇒ C → LG A ⊗ B ⊢ C
  res-⊗⇒ : ∀ {A B C}   → LG A ⊗ B ⊢ C → LG B ⊢ A ⇒ C
  res-⇐⊗ : ∀ {A B C}   → LG A ⊢ C ⇐ B → LG A ⊗ B ⊢ C
  res-⊗⇐ : ∀ {A B C}   → LG A ⊗ B ⊢ C → LG A ⊢ C ⇐ B

  -- rules for co-residuation and co-monotonicity
  mon-⊕  : ∀ {A B C D} → LG A ⊢ B → LG C ⊢ D → LG A ⊕ C ⊢ B ⊕ D
  mon-⇛  : ∀ {A B C D} → LG A ⊢ B → LG C ⊢ D → LG D ⇛ A ⊢ C ⇛ B
  mon-⇚  : ∀ {A B C D} → LG A ⊢ B → LG C ⊢ D → LG A ⇚ D ⊢ B ⇚ C
  res-⇛⊕ : ∀ {A B C}   → LG B ⇛ C ⊢ A → LG C ⊢ B ⊕ A
  res-⊕⇛ : ∀ {A B C}   → LG C ⊢ B ⊕ A → LG B ⇛ C ⊢ A
  res-⊕⇚ : ∀ {A B C}   → LG C ⊢ B ⊕ A → LG C ⇚ A ⊢ B
  res-⇚⊕ : ∀ {A B C}   → LG C ⇚ A ⊢ B → LG C ⊢ B ⊕ A

  -- grishin distributives
  grish₁ : ∀ {A B C D} → LG A ⊗ B ⊢ C ⊕ D → LG C ⇛ A ⊢ D ⇐ B
  grish₂ : ∀ {A B C D} → LG A ⊗ B ⊢ C ⊕ D → LG C ⇛ B ⊢ A ⇒ D
  grish₃ : ∀ {A B C D} → LG A ⊗ B ⊢ C ⊕ D → LG B ⇚ D ⊢ A ⇒ C
  grish₄ : ∀ {A B C D} → LG A ⊗ B ⊢ C ⊕ D → LG A ⇚ D ⊢ C ⇐ B



-- Derived rule for identity, which holds as long as the type A only
-- connectives from the non-associative Lambek calculus `LG`.
id′ : ∀ {A} → LG A ⊢ A
id′ {el A}  = id
id′ {A ⊗ B} = mon-⊗ id′ id′
id′ {A ⇚ B} = mon-⇚ id′ id′
id′ {A ⇛ B} = mon-⇛ id′ id′
id′ {A ⊕ B} = mon-⊕ id′ id′
id′ {A ⇐ B} = mon-⇐ id′ id′
id′ {A ⇒ B} = mon-⇒ id′ id′

-- Derived rules for two-step residuations.
res-⇐⇒′ : ∀ {A B C} → LG A ⊢ C ⇐ B → LG B ⊢ A ⇒ C
res-⇐⇒′ = res-⊗⇒ ∘ res-⇐⊗
res-⇒⇐′ : ∀ {A B C} → LG B ⊢ A ⇒ C → LG A ⊢ C ⇐ B
res-⇒⇐′ = res-⊗⇐ ∘ res-⇒⊗

-- Derived rules for two-step co-residuations.
res-⇚⇒′ : ∀ {A B C} → LG C ⇚ A ⊢ B → LG B ⇛ C ⊢ A
res-⇚⇒′ = res-⊕⇛ ∘ res-⇚⊕
res-⇒⇚′ : ∀ {A B C} → LG B ⇛ C ⊢ A → LG C ⇚ A ⊢ B
res-⇒⇚′ = res-⊕⇚ ∘ res-⇛⊕

-- Derived rules for application.
appl-⇒′ : ∀ {A B} → LG A ⊗ (A ⇒ B) ⊢ B
appl-⇒′ = res-⇒⊗ id′
appl-⇐′ : ∀ {A B} → LG (B ⇐ A) ⊗ A ⊢ B
appl-⇐′ = res-⇐⊗ id′

-- Derived rules for co-application.
appl-⇛′ : ∀ {A B} → LG B ⊢ A ⊕ (A ⇛ B)
appl-⇛′ = res-⇛⊕ id′
appl-⇚′ : ∀ {A B} → LG B ⊢ (B ⇚ A) ⊕ A
appl-⇚′ = res-⇚⊕ id′


infix 5 is-id_ is-id?_

-- Heterogeneous equality of proofs, checking if the proof is equal to
-- the identity proof.
is-id_ : ∀ {A B} (f : LG A ⊢ B) → Set ℓ
is-id_ f = ∃ (λ A → f ≅ id {A})


-- Decision procedure for heterogeneous equality of proofs, checking
-- if the proof is equal to the identity proof.
is-id?_ : ∀ {A B} (f : LG A ⊢ B) → Dec (is-id f)
is-id? id         = yes (_ , H.refl)
is-id? mon-⊗  _ _ = no (λ {(_ , ())})
is-id? mon-⇒  _ _ = no (λ {(_ , ())})
is-id? mon-⇐  _ _ = no (λ {(_ , ())})
is-id? res-⇒⊗ _   = no (λ {(_ , ())})
is-id? res-⊗⇒ _   = no (λ {(_ , ())})
is-id? res-⇐⊗ _   = no (λ {(_ , ())})
is-id? res-⊗⇐ _   = no (λ {(_ , ())})
is-id? res-⇛⊕ _   = no (λ {(_ , ())})
is-id? res-⊕⇛ _   = no (λ {(_ , ())})
is-id? res-⊕⇚ _   = no (λ {(_ , ())})
is-id? res-⇚⊕ _   = no (λ {(_ , ())})
is-id? mon-⊕  _ _ = no (λ {(_ , ())})
is-id? mon-⇛  _ _ = no (λ {(_ , ())})
is-id? mon-⇚  _ _ = no (λ {(_ , ())})
is-id? grish₁ _   = no (λ {(_ , ())})
is-id? grish₂ _   = no (λ {(_ , ())})
is-id? grish₃ _   = no (λ {(_ , ())})
is-id? grish₄ _   = no (λ {(_ , ())})