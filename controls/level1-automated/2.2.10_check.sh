
#!/usr/bin/env bash

# Function to check if IMAP and POP3 servers are installed
check_imap_pop3_installed() {
  dovecot_imap_status=$(dpkg-query -W -f='${db:Status-Status}' dovecot-imapd 2>/dev/null)
  dovecot_pop3_status=$(dpkg-query -W -f='${db:Status-Status}' dovecot-pop3d 2>/dev/null)

  if [ "$dovecot_imap_status" = "installed" ] || [ "$dovecot_pop3_status" = "installed" ]; then
    return 0
  fi

  return 1
}

# Main script execution
{
  if check_imap_pop3_installed; then
    echo -e "\n2.2.10 Ensure IMAP and POP3 Server are not installed --> \e[31mfailed\e[0m"
    echo -e "The following packages are installed:\n"
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' dovecot-imapd dovecot-pop3d 2>/dev/null
  else
    echo -e "\n2.2.10 Ensure IMAP and POP3 Server are not installed --> \033[0;32mpassed\033[0m"
    echo -e "The IMAP and POP3 server packages (dovecot-imapd and dovecot-pop3d) are not installed.\n"
  fi
}
