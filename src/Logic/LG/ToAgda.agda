------------------------------------------------------------------------
-- The Lambek Calculus in Agda
------------------------------------------------------------------------


open import Function     using (id; _∘_)
open import Data.Product using (_×_; _,_; proj₁; proj₂; uncurry)
open import Relation.Binary.PropositionalEquality as P


module Logic.LG.ToAgda
  {a ℓ} (Atom : Set a) (R : Set ℓ) (⌈_⌉ᵁ : Atom → Set ℓ) where


open import Logic.Polarity
open import Logic.Translation
open import Logic.LG.Type                Atom
open import Logic.LG.Structure.Polarised Atom
open import Logic.LG.Judgement           Atom
open import Logic.LG.Base                Atom


private
  infix 3 ¬_

  ¬_ : Set ℓ → Set ℓ
  ¬ A = A → R

  deMorgan : {A B : Set ℓ} → (¬ ¬ A) → (¬ ¬ B) → ¬ ¬ (A × B)
  deMorgan c₁ c₂ k = c₁ (λ x → c₂ (λ y → k (x , y)))


-- * Call-by-value translation

private
  ⌈_⌉ᵗ : Type → Set ℓ
  ⌈ el  A ⌉ᵗ =      ⌈ A ⌉ᵁ
  ⌈ ◇   A ⌉ᵗ =      ⌈ A ⌉ᵗ
  ⌈ □   A ⌉ᵗ =      ⌈ A ⌉ᵗ
  ⌈ ₀   A ⌉ᵗ = ¬    ⌈ A ⌉ᵗ
  ⌈ A   ⁰ ⌉ᵗ = ¬    ⌈ A ⌉ᵗ
  ⌈ ₁   A ⌉ᵗ = ¬    ⌈ A ⌉ᵗ
  ⌈ A   ¹ ⌉ᵗ = ¬    ⌈ A ⌉ᵗ
  ⌈ A ⊗ B ⌉ᵗ =   (  ⌈ A ⌉ᵗ ×   ⌈ B ⌉ᵗ)
  ⌈ A ⇒ B ⌉ᵗ =   (¬ ⌈ B ⌉ᵗ → ¬ ⌈ A ⌉ᵗ)
  ⌈ B ⇐ A ⌉ᵗ =   (¬ ⌈ B ⌉ᵗ → ¬ ⌈ A ⌉ᵗ)
  ⌈ B ⊕ A ⌉ᵗ = ¬ (¬ ⌈ B ⌉ᵗ × ¬ ⌈ A ⌉ᵗ)
  ⌈ B ⇚ A ⌉ᵗ = ¬ (¬ ⌈ A ⌉ᵗ → ¬ ⌈ B ⌉ᵗ)
  ⌈ A ⇛ B ⌉ᵗ = ¬ (¬ ⌈ A ⌉ᵗ → ¬ ⌈ B ⌉ᵗ)


  ⌈_⌉ˢ_ : ∀ {p} → Structure p → Polarity → Set ℓ
  ⌈ X ⌉ˢ q = flatten (λ { + A → ⌈ A ⌉ᵗ ; - A → ¬ ⌈ A ⌉ᵗ }) q X
    where
      flatten : ∀ {p} (f : Polarity → Type → Set ℓ) (q : Polarity) (X : Structure p) → Set ℓ
      flatten f + ·  A  · = f + A
      flatten f - ·  A  · = f - A
      flatten f _ [  X  ] = flatten f - X
      flatten f _ ⟨  X  ⟩ = flatten f + X
      flatten f _ (₀   X) = flatten f + X
      flatten f _ (X   ⁰) = flatten f + X
      flatten f _ (₁   X) = flatten f - X
      flatten f _ (X   ¹) = flatten f - X
      flatten f _ (X ⊗ Y) = flatten f + X × flatten f + Y
      flatten f _ (X ⇚ Y) = flatten f + X × flatten f - Y
      flatten f _ (X ⇛ Y) = flatten f - X × flatten f + Y
      flatten f _ (X ⊕ Y) = flatten f - X × flatten f - Y
      flatten f _ (X ⇒ Y) = flatten f + X × flatten f - Y
      flatten f _ (X ⇐ Y) = flatten f - X × flatten f + Y

  ⌈_⌉ʲ : Judgement → Set ℓ
  ⌈   X  ⊢  Y   ⌉ʲ = ⌈ X ⌉ˢ + → ⌈ Y ⌉ˢ - → R
  ⌈ [ A ]⊢  Y   ⌉ʲ = ⌈ Y ⌉ˢ - →   ¬ ⌈ A ⌉ᵗ
  ⌈   X  ⊢[ B ] ⌉ʲ = ⌈ X ⌉ˢ + → ¬ ¬ ⌈ B ⌉ᵗ


  ⌈_⌉ : ∀ {J} → LG J → ⌈ J ⌉ʲ
  ⌈ ax⁺     ⌉ x y = y x
  ⌈ ax⁻     ⌉ x y = x y
  ⌈ ⇁   f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ↽   f   ⌉ x y = ⌈ f ⌉ y x
  ⌈ ⇀   f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ↼   f   ⌉ x y = ⌈ f ⌉ y x
  ⌈ ◇ᴸ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ◇ᴿ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ □ᴸ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ □ᴿ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ r□◇ f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ r◇□ f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ₀ᴸ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ₀ᴿ  f   ⌉ x y = y (⌈ f ⌉ x)
  ⌈ ⁰ᴸ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ⁰ᴿ  f   ⌉ x y = y (⌈ f ⌉ x)
  ⌈ ₁ᴸ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ₁ᴿ  f   ⌉ x y = y (⌈ f ⌉ x)
  ⌈ ¹ᴸ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ¹ᴿ  f   ⌉ x y = y (⌈ f ⌉ x)
  ⌈ r⁰₀ f   ⌉ x y = ⌈ f ⌉ y x
  ⌈ r₀⁰ f   ⌉ x y = ⌈ f ⌉ y x
  ⌈ r¹₁ f   ⌉ x y = ⌈ f ⌉ y x
  ⌈ r₁¹ f   ⌉ x y = ⌈ f ⌉ y x
  ⌈ ⊗ᴸ  f   ⌉ x y = ⌈ f ⌉ x y
  ⌈ ⊗ᴿ  f g ⌉ (x , y) k = deMorgan (⌈ f ⌉ x) (⌈ g ⌉ y) k
  ⌈ ⇒ᴸ  f g ⌉ (x , y) k = deMorgan (λ k → k (⌈ g ⌉ y)) (⌈ f ⌉ x) (uncurry k)
  ⌈ ⇒ᴿ  f   ⌉ x k = k (λ y z → ⌈ f ⌉ x (z , y))
  ⌈ ⇐ᴸ  f g ⌉ (x , y) k = deMorgan (λ k → k (⌈ g ⌉ x)) (⌈ f ⌉ y) (uncurry k)
  ⌈ ⇐ᴿ  f   ⌉ x k = k (λ y z → ⌈ f ⌉ x (y , z))
  ⌈ r⇒⊗ f   ⌉ (x , y) z = ⌈ f ⌉ y (x , z)
  ⌈ r⊗⇒ f   ⌉ x (y , z) = ⌈ f ⌉ (y , x) z
  ⌈ r⇐⊗ f   ⌉ (x , y) z = ⌈ f ⌉ x (z , y)
  ⌈ r⊗⇐ f   ⌉ x (y , z) = ⌈ f ⌉ (x , z) y
  ⌈ ⊕ᴸ  f g ⌉ (x , y) k = k (⌈ f ⌉ x , ⌈ g ⌉ y)
  ⌈ ⊕ᴿ  f   ⌉ x k = k (λ {y → ⌈ f ⌉ x y})
  ⌈ ⇚ᴸ  f   ⌉ k x = k (λ y z → ⌈ f ⌉ (z , y) x)
  ⌈ ⇚ᴿ  f g ⌉ (x , y) k = k (λ k → deMorgan (λ k → k (⌈ g ⌉ y)) (⌈ f ⌉ x) (uncurry k))
  ⌈ ⇛ᴸ  f   ⌉ k x = k (λ y z → ⌈ f ⌉ (y , z) x)
  ⌈ ⇛ᴿ  f g ⌉ (x , y) k = k (λ k → deMorgan (λ k → k (⌈ g ⌉ x)) (⌈ f ⌉ y) (uncurry k))
  ⌈ r⇚⊕ f   ⌉ x (y , z) = ⌈ f ⌉ (x , z) y
  ⌈ r⊕⇚ f   ⌉ (x , y) z = ⌈ f ⌉ x (z , y)
  ⌈ r⇛⊕ f   ⌉ x (y , z) = ⌈ f ⌉ (y , x) z
  ⌈ r⊕⇛ f   ⌉ (x , y) z = ⌈ f ⌉ y (x , z)
  ⌈ d⇛⇐ f   ⌉ (x , y) (z , w) = ⌈ f ⌉ (y , w) (x , z)
  ⌈ d⇛⇒ f   ⌉ (x , y) (z , w) = ⌈ f ⌉ (z , y) (x , w)
  ⌈ d⇚⇒ f   ⌉ (x , y) (z , w) = ⌈ f ⌉ (z , x) (w , y)
  ⌈ d⇚⇐ f   ⌉ (x , y) (z , w) = ⌈ f ⌉ (x , w) (z , y)


CBV : Translation Type (Set ℓ) LG_ id
CBV = record { ⟦_⟧ᵗ = ⌈_⌉ᵗ ; ⟦_⟧ʲ = ⌈_⌉ʲ ; [_]  = ⌈_⌉ }


-- * Call-by-name translation

private
  ⌊_⌋ᵗ : Type → Set ℓ
  ⌊ A ⌋ᵗ = ⌈ A ∞ ⌉ᵗ

  ⌊_⌋ʲ : Judgement → Set ℓ
  ⌊ J ⌋ʲ = ⌈ J ∞ʲ ⌉ʲ

  ⌊_⌋ : ∀ {J} → LG J → ⌊ J ⌋ʲ
  ⌊ f ⌋ = ⌈ f ∞ᵗ ⌉

CBN : Translation Type (Set ℓ) LG_ id
CBN = record
  { ⟦_⟧ᵗ = ⌊_⌋ᵗ
  ; ⟦_⟧ʲ = ⌊_⌋ʲ
  ; [_]  = ⌊_⌋
  }
