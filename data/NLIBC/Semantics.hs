{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleInstances, FlexibleContexts,
    TypeFamilies, GADTs, TypeOperators, DataKinds, PolyKinds, RankNTypes,
    KindSignatures, UndecidableInstances, StandaloneDeriving, PatternSynonyms,
    AllowAmbiguousTypes, ScopedTypeVariables,InstanceSigs #-}
module NLIBC.Semantics where


import           Prelude hiding ((!!),abs,pred)
import           Control.Monad.State
import           NLIBC.Syntax (Prf(..),Sequent(..))
import qualified NLIBC.Syntax as S
import           Data.Set (Set)
import qualified Data.Set as Set
import           Data.Singletons.Decide
import           Data.Singletons.Prelude
import           Data.Singletons.TH (promote,promoteOnly,singletons)
import           Text.Printf (printf)
import           Unsafe.Coerce (unsafeCoerce)


data E
data T


singletons [d|

  data Nat = Z | S Nat
     deriving (Eq,Show,Ord)

  |]

promote [d|

  (!!) :: [a] -> Nat -> a
  []     !! _     = error "!!: index out of bounds"
  (x:_ ) !! Z  = x
  (x:xs) !! S n = xs !! n

  |]


nat :: Nat -> Int
nat  Z    = 0
nat (S n) = 1 + nat n


class Sem (repr :: [*] -> * -> *) where
  var  :: SNat n -> repr ts (ts :!! n)
  abs  :: repr (t1 ': ts) t2 -> repr ts (t1 -> t2)
  app  :: repr ts (t1 -> t2) -> repr ts t1 -> repr ts t2
  top  :: repr ts ()
  pair :: repr ts t1 -> repr ts t2 -> repr ts (t1, t2)
  p1   :: repr ts (t1, t2) -> repr ts t1
  p2   :: repr ts (t1, t2) -> repr ts t2


v0 :: Sem repr => repr (t0 ': ts) t0
v0  = var SZ
v1 :: Sem repr => repr (t0 ': t1 ': ts) t1
v1  = var (SS SZ)
v2 :: Sem repr => repr (t0 ': t1 ': t2 ': ts) t2
v2  = var (SS (SS SZ))
v3 :: Sem repr => repr (t0 ': t1 ': t2 ': t3 ': ts) t3
v3  = var (SS (SS (SS SZ)))
v4 :: Sem repr => repr (t0 ': t1 ': t2 ': t3 ': t4 ': ts) t4
v4  = var (SS (SS (SS (SS SZ))))
v5 :: Sem repr => repr (t0 ': t1 ': t2 ': t3 ': t4 ': t5 ': ts) t5
v5  = var (SS (SS (SS (SS (SS SZ)))))


type family H a where
  H (S.El S.S)      = T
  H (S.El S.N)      = (E -> T)
  H (S.El S.NP)     = E
  H (S.El S.PP)     = E
  H (S.El S.INF)    = (E -> T)
  H (S.Dia k a)     = H a
  H (S.Box k a)     = H a
  H (a S.:& b)      = (H a, H b)
  H (S.UnitR k a)   = (H a, ())
  H (S.ImpR k a b)  = H a -> H b
  H (S.ImpL k b a)  = H a -> H b

type family HI x where
  HI (S.StI  a)     = H a
  HI (S.DIA k x)    = HI x
  HI  S.B           = ()
  HI  S.C           = ()
  HI (S.UNIT k)     = ()
  HI (S.PROD k x y) = (HI x, HI y)

type family HO x where
  HO (S.StO  a)     = H  a
  HO (S.BOX k x)    = HO x
  HO (S.IMPR k x y) = HI x -> HO y
  HO (S.IMPL k y x) = HI x -> HO y

type family HS s where
  HS (x :⊢  y)      = HI x -> HO y
  HS (x :⊢> b)      = HI x -> H  b
  HS (a :<⊢ y)      = H  a -> HO y


eta :: Sem repr => Prf s -> repr ts (HS s)
eta (AxR     _) = abs v0
eta (AxL     _) = abs v0
eta (UnfR  _ f) = eta f
eta (UnfL  _ f) = eta f
eta (FocR  _ f) = eta f
eta (FocL  _ f) = eta f
eta (WithL1  f) = abs (eta f `app` p1 v0)
eta (WithL2  f) = abs (eta f `app` p2 v0)
eta (WithR f g) = abs (pair (eta f `app` v0) (eta g `app` v0))
eta (ImpRL f g) = abs (abs (eta g `app` (v1 `app` (eta f `app` v0))))
eta (ImpRR   f) = eta f
eta (ImpLL f g) = abs (abs (eta g `app` (v1 `app` (eta f `app` v0))))
eta (ImpLR   f) = eta f
eta (Res11   f) = abs ((eta f `app` p2 v0) `app` p1 v0)
eta (Res12   f) = abs (abs (eta f `app` (pair v0 v1)))
eta (Res13   f) = abs ((eta f `app` p1 v0) `app` p2 v0)
eta (Res14   f) = abs (abs (eta f `app` (pair v1 v0)))
eta (DiaL    f) = eta f
eta (DiaR    f) = eta f
eta (BoxL    f) = eta f
eta (BoxR    f) = eta f
eta (Res21   f) = eta f
eta (Res22   f) = eta f
eta (UnitRL  f) = abs (eta f `app` v0)
eta (UnitRR  f) = abs (pair (eta f `app` p1 v0) top)
eta (UnitRI  f) = abs (eta f `app` p1 v0)
eta (UpB     f) = abs (eta f `app` pair (p2 (p1 (p2 v0))) (pair (p1 v0) (p2 (p2 v0))))
eta (DnB     f) = abs (eta f `app` pair (p1 (p2 v0)) (pair (pair top (p1 v0)) (p2 (p2 v0))))
eta (UpC     f) = abs (eta f `app` pair (pair (p1 v0) (p2 (p1 (p2 v0)))) (p2 (p2 v0)))
eta (DnC     f) = abs (eta f `app` pair (p1 (p1 v0)) (pair (pair top (p2 (p1 v0))) (p2 v0)))


-- * Translate to Haskell

type family ToHask t where
  ToHask E        = Int
  ToHask T        = Bool
  ToHask ()       = ()
  ToHask (a -> b) = ToHask a -> ToHask b
  ToHask (a ,  b) = (ToHask a, ToHask b)

data Env (ts :: [*]) where
  Nil  :: Env '[]
  Cons :: ToHask t -> Env ts -> Env (t ': ts)

(%!!) :: Env ts -> SNat n -> ToHask (ts :!! n)
(%!!)  Nil         _     = error "%!!: index out of bounds"
(%!!) (Cons x _ )  SZ    = x
(%!!) (Cons x xs) (SS n) = xs %!! n

newtype Hask (ts :: [*]) (t :: *) = Hask { runHask :: Env ts -> ToHask t }

instance Sem Hask where
  var  n   = Hask $ \env -> env %!! n
  abs  f   = Hask $ \env x -> runHask f (Cons x env)
  app  f x = Hask $ \env -> runHask f env (runHask x env)
  top      = Hask $ const ()
  pair x y = Hask $ \env -> (runHask x env , runHask y env)
  p1   x   = Hask $ \env -> fst (runHask x env)
  p2   x   = Hask $ \env -> snd (runHask x env)

eval :: ToHask (HI x) -> Prf (x :⊢ y) -> ToHask (HO y)
eval x f = runHask (eta f `app` (Hask (const x))) Nil







-- -}
-- -}
-- -}
-- -}
-- -}
