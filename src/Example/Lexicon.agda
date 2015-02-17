------------------------------------------------------------------------
-- The Lambek Calculus in Agda
------------------------------------------------------------------------

open import Function
open import Data.Bool                             using (Bool; true; false; _∧_)
open import Data.Fin                              using (Fin; suc; zero; #_; toℕ)
open import Data.List                             using (List; map; all; any; _++_) renaming ([] to ∅; _∷_ to _,_)
open import Data.Nat                              using (ℕ; suc; zero)
open import Data.Product                          using (_,_)
open import Relation.Nullary                      using (Dec; yes; no)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)


module Example.Lexicon where


Entity = Fin 3


open import Example.Base Entity as Base public
     hiding (module UsingLambdaCMinus; module UsingLambekGrishin)


abstract
  domainₑ : List Entity
  domainₑ = go
    where
      go : ∀ {n} → List (Fin n)
      go {zero } = ∅
      go {suc n} = zero , map suc go

  forallₑ : (Entity → Bool) → Bool
  forallₑ p = all p domainₑ

  existsₑ : (Entity → Bool) → Bool
  existsₑ p = any p domainₑ

  john mary bill : Entity
  john = # 0
  bill = # 1
  mary = # 2

  _lovedBy_ : Entity → Entity → Bool
  zero     lovedBy suc zero       = true
  suc zero lovedBy zero           = true
  suc zero lovedBy suc zero       = true
  suc zero lovedBy suc (suc zero) = true
  _        lovedBy _              = false

  person : Entity → Bool
  person _ = true


module UsingLambdaCMinus where

  open Base.UsingLambdaCMinus public

  JOHN   = el NP
  BILL   = el NP
  MARY   = el NP
  LOVES  = (el NP ⇒ el S) ⇐ el NP
  PERSON = el N

  loves : ⟦ LOVES ⟧ᵀ
  loves = λ k x → k (λ k y → k (x lovedBy y))


module UsingLambekGrishin where

  open Base.UsingLambekGrishin public

  JOHN   = el NP
  BILL   = el NP
  MARY   = el NP
  LOVES  = (el NP ⇒ el S) ⇐ el NP
  PERSON = el N
