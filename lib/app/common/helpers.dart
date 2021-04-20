
class BankAccountHelper{

  static String ApplyMaskToAccout(String account) {
    if (account==null || account.trim().length==0)
      return "";

    if (account.length==20)
        return '****-****-**-******${account.substring(account.length-4)}';

    if (account.length==24)
      return '${account.substring(0,4)}-${account.substring(4,8)} - **** - ** - ******${account.substring(account.length-4)}';

    return "no válida";
  }


}