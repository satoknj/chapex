class Chapex::Parser::Apex
rule
  program: class_dec {
    result = @builder.program([val[0]])
  }
  class_dec: scope virtual abstract sharing class ident L_CB class_body  implemation inherit R_CB {
    children = val[0, 6] << val[7]
    result = @builder.class_dec(children)
  }
  implemation:
            | implements ident
  inherit:
            | extends ident
  class_body:
          | members
  members: member {
            result = @builder.class_body([val[0]])
          }
          | members member {
            result = val[0] << val[1]
          }
  member: field 
        | method
  field: scope ident ident SEMI {
            result =  @builder.field(val[0, 3])
          }
  method: scope ident ident L_RB R_RB L_CB method_body R_CB {
            children = val[0, 3].concat([val[6]])
            result =  @builder.method(children)
          }
  method_body: stmt {
          result = @builder.method_body([val[0]])
          }
        | method_body stmt {
          result = val[0] << val[1]
        }
  stmt: rhs {
          result = @builder.stmt([val[0]])
        }
  rhs: call_target L_RB argments R_RB SEMI {
                  result = @builder.join_as_node(:rhs, val[0], val[2])
                }
  call_target: ident
             | ident dot_idents {
               result = @builder.join_as_node(:call_target, *val)
             }
  dot_idents:  dot_ident {
              result = val[0]
            }
            | dot_idents dot_ident {
              result = val[0] << val[1]
            }
  dot_ident: DOT ident {
              result = @builder.join_as_node(:dot_ident, *val)
            }
  argments: S_LITERAL
  class: CLASS {
        result = @builder.terminal_node(:class, val[0])
       }
  scope: {
        result = @builder.terminal_node(:scope, nil)
       }
       | SCOPE {
        result = @builder.terminal_node(:scope, val[0])
       }
  ident: IDENT {
        result = @builder.terminal_node(:ident, val[0])
      }
  virtual: {
        result = @builder.terminal_node(:virtual, nil)
       }
       | VIRTUAL {
        result = @builder.terminal_node(:virtual, val[0])
       }
  abstract: {
        result = @builder.terminal_node(:abstract, nil)
       }
       | ABSTRACT {
        result = @builder.terminal_node(:abstract, val[0])
       }
  sharing: {
        result = @builder.terminal_node(:sharing, nil)
       }
       | SHARING {
        result = @builder.terminal_node(:sharing, val[0])
       }
  implements: IMPLEMENTS {
        result = @builder.terminal_node(:implements, val[0])
       }
  extends: EXTENDS {
        result = @builder.terminal_node(:extends, val[0])
       }
end
