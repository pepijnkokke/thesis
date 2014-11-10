------------------------------------------------------------------------
-- The Lambek Calculus in Agda
--
------------------------------------------------------------------------


open import Categories
open import Function using (flip)
open import Function.Equivalence using (equivalence)
open import Algebra.ResiduatedAlgebra
open import Relation.Binary using (Rel)
open import Relation.Binary.PropositionalEquality as P using (_≡_)


module Logic.Lambek.ResMon.Complete {ℓ} (Univ : Set ℓ) where


open import Logic.Lambek.Type             Univ as T
open import Logic.Lambek.ResMon.Judgement Univ as RMJ
open import Logic.Lambek.ResMon.Base      Univ as RMB
open import Logic.Lambek.ResMon.Trans     Univ as RMT


private
  _≤_ : Rel Type ℓ
  A ≤ B = NL A ⊢ B


open import Relation.Binary.PartialOrderToEquivalence _≤_ id′ trans′


isResiduatedAlgebra : IsResiduatedAlgebra _≈_ _≤_ _⊗_ _⇒_ _⇐_
isResiduatedAlgebra = record
  { isPartialOrder = isPartialOrder
  ; residual-⇒     = equivalence res-⇒⊗ res-⊗⇒
  ; residual-⇐     = equivalence res-⊗⇐ res-⇐⊗
  ; ∙-resp-≤       = mon-⊗
  }


resiuatedAlgebra : ResiduatedAlgebra _ _ _
resiuatedAlgebra = record
  { Carrier             = Type
  ; _≈_                 = _≈_
  ; _≤_                 = _≤_
  ; _∙_                 = _⊗_
  ; _⇒_                 = _⇒_
  ; _⇐_                 = _⇐_
  ; isResiduatedAlgebra = isResiduatedAlgebra
  }