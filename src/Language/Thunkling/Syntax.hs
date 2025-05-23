module Language.Thunkling.Syntax
  ( Name (..),
    Phase (..),
    Ann (..),
    Program (..),
    TopLevelBind (..),
    Param (..),
    ExprTy (..),
    Expr (..),
  ) where

newtype Name = Name {unName :: Text}
  deriving stock (Eq, Ord, Show)
  deriving newtype (IsString)

data Phase
  = Parsed
  deriving stock
    ( Eq,
      Enum,
      Ord,
      Show
    )

data family Ann (phase :: Phase)

newtype instance Ann 'Parsed
  = ParsedAnn (Maybe ExprTy)
  deriving stock (Eq, Show)

newtype Program phase = Program {unProgram :: [TopLevelBind phase]}

deriving instance Eq (Program 'Parsed)
deriving instance Show (Program 'Parsed)

data TopLevelBind (phase :: Phase) = TopLevelBind
  { bindName :: Name,
    bindAnn :: Ann phase,
    bindParams :: [Param],
    bindExpr :: Expr phase
  }

deriving instance Eq (TopLevelBind 'Parsed)
deriving instance Show (TopLevelBind 'Parsed)

newtype Param = Param {unParam :: Name}
  deriving stock (Eq, Ord, Show)
  deriving newtype (IsString)

data ExprTy
  = TyArrow ExprTy ExprTy
  | TyInt
  | TyBool
  | TyUnit
  deriving (Eq, Show)

data Expr (phase :: Phase) where
  Var :: Ann phase -> Name -> Expr phase
  App :: Ann phase -> Expr phase -> Expr phase -> Expr phase
  Abs :: Ann phase -> Param -> Expr phase -> Expr phase
  Add :: Ann phase -> Expr phase -> Expr phase -> Expr phase
  Sub :: Ann phase -> Expr phase -> Expr phase -> Expr phase
  LitInt :: Ann phase -> Int -> Expr phase
  LitBool :: Ann phase -> Bool -> Expr phase
  LitString :: Ann phase -> Text -> Expr phase
  LitUnit :: Ann phase -> Expr phase

deriving instance Eq (Expr 'Parsed)
deriving instance Show (Expr 'Parsed)
