import 'package:giv_flutter/config/i18n/string_localizations.dart';

class Strings {
  static String formatItem = StringLocalizations.formatItemSymbol;

  static Map<String, Map<String, String>> map = {
    "app_name": {"en": "Alguém Quer?", "pt": "Alguém Quer?"},
    "home_title": {"en": "Home", "pt": "Início"},
    "common_more": {"en": "More", "pt": "Mais"},
    "base_page_title_home": {"en": "Home", "pt": "Início"},
    "base_page_title_search": {"en": "Search", "pt": "Explorar"},
    "base_page_title_post": {"en": "Post", "pt": "Alguém Quer?"},
    "base_page_title_messages": {"en": "Messages", "pt": "Mensagens"},
    "base_page_title_projects": {"en": "Projects", "pt": "Projetos"},
    "base_page_create_donation_action": {
      "en": "I want do give something away",
      "pt": "Quero doar algo"
    },
    "base_page_create_donation_request_action": {
      "en": "I want ask for something",
      "pt": "Quero fazer um pedido de doação"
    },
    "search_hint": {"en": "search...", "pt": "busque..."},
    "search_result_x_results": {
      "en": "$formatItem Results",
      "pt": "$formatItem Resultados"
    },
    "search_result_empty_state_nothing_in_your_city": {
      "en": "We didn't find anything in your city",
      "pt": "Não encontramos nada na sua cidade."
    },
    "search_result_empty_state_nothing_from_category_in_your_city": {
      "en": "We didn't finy any $formatItem in your city.",
      "pt": "Não encontramos nada de $formatItem na sua cidade."
    },
    "search_result_empty_state_nothing_from_search_term_in_your_city": {
      "en": "We didn't finy anything for \"$formatItem\" in your city.",
      "pt": "Não encontramos nada de \"$formatItem\" na sua cidade."
    },
    "search_result_empty_state_nothing_in_your_state": {
      "en": "We didn't finy anything in your state.",
      "pt": "Não encontramos nada no seu estado."
    },
    "search_result_empty_state_nothing_from_category_in_your_state": {
      "en": "We didn't finy any $formatItem in your state.",
      "pt": "Não encontramos nada de $formatItem no seu estado."
    },
    "search_result_empty_state_nothing_from_search_term_in_your_state": {
      "en": "We didn't finy anything for \"$formatItem\" in your state.",
      "pt": "Não encontramos nada de \"$formatItem\" no seu estado."
    },
    "search_result_empty_state_nothing": {
      "en": "We didn't find anything.",
      "pt": "Não encontramos nada."
    },
    "search_result_empty_state_nothing_from_category": {
      "en": "We didn't find any $formatItem.",
      "pt": "Não encontramos nada de $formatItem."
    },
    "search_result_empty_state_nothing_from_search_term": {
      "en": "We didn't finy anything for \"$formatItem\".",
      "pt": "Não encontramos nada de \"$formatItem\"."
    },
    "action_continue": {"en": "Continue", "pt": "Continuar"},
    "action_filter": {"en": "Filter", "pt": "Filtrar"},
    "action_location_filter": {
      "en": "Filter by location",
      "pt": "Filtrar por localização"
    },
    "filters_title": {"en": "Filters", "pt": "Filtros"},
    "common_country": {"en": "Country", "pt": "País"},
    "common_state": {"en": "State", "pt": "Estado"},
    "common_city": {"en": "City", "pt": "Cidade"},
    "filters_subtitle_nearby": {"en": "Nearby", "pt": "Perto de mim"},
    "common_loading": {"en": "Loading...", "pt": "Carregando..."},
    "location_filter_title": {"en": "Location", "pt": "Localização"},
    "location_filter_help_text_title": {
      "en": "Where you at?",
      "pt": "Onde você está?"
    },
    "location_filter_help_text_default": {
      "en":
          "Before continuing, please choose your city so that we can show listings closer to you first.",
      "pt":
          "Antes de continuar, informe sua cidade para que possamos priorizar anúncios mais pertos de você."
    },
    "location_filter_help_text_settings": {
      "en":
          "Choose your city so that we can show listings closer to you first.",
      "pt":
          "Informe sua cidade para que possamos priorizar anúncios mais pertos de você."
    },
    "location_filter_error_country_required": {
      "en": "Choose a country",
      "pt": "Escolha um país"
    },
    "location_filter_error_state_required": {
      "en": "Choose a state",
      "pt": "Escolha um estado"
    },
    "location_filter_error_city_required": {
      "en": "Choose a city",
      "pt": "Escolha uma cidade"
    },
    "i_want_it": {"en": "I want it", "pt": "Eu quero"},
    "i_want_to_help": {"en": "I want to help", "pt": "Eu quero ajudar"},
    "home_see_more": {"en": "View all", "pt": "Veja mais"},
    "shared_action_create_ad": {"en": "Donate stuff", "pt": "Anunciar"},
    "shared_action_sign_in": {"en": "Sign in", "pt": "Entrar"},
    "sign_in_continue_with_facebook": {
      "en": "Continue with Facebook",
      "pt": "Continuar com Facebook"
    },
    "sign_in_continue_with_apple": {
      "en": "Sign in with Apple",
      "pt": "Continuar com a Apple"
    },
    "sign_in_sign_up": {"en": "Sign up", "pt": "Criar conta"},
    "sign_in_log_in": {"en": "Log in", "pt": "Entrar"},
    "sign_in_form_name": {"en": "Name", "pt": "Nome"},
    "sign_in_form_email": {"en": "Email", "pt": "E-mail"},
    "sign_in_form_password": {"en": "Password", "pt": "Senha"},
    "sign_in_already_have_an_acount": {
      "en": "Already have an account?",
      "pt": "Já tem uma conta?"
    },
    "sign_in_forgot_password": {
      "en": "Forgot your password?",
      "pt": "Esqueceu sua senha?"
    },
    "sign_in_dont_have_an_account": {
      "en": "Don't have an account yet?",
      "pt": "Ainda não tem uma conta?"
    },
    "validation_message_name_required": {
      "en": "Don't forget to fill in your name",
      "pt": "Não se esqueça de preencher seu nome"
    },
    "validation_message_email_required": {
      "en": "We need a valid email address :)",
      "pt": "Precisamos que você informe um e-mail válido :)"
    },
    "validation_message_password_min_length": {
      "en": "Your password should be at least 6 characters long",
      "pt": "Sua senha deve ter no mínimo 6 caracteres"
    },
    "validation_message_password_not_only_whitspaces": {
      "en": "Your password can't be just whitespaces",
      "pt": "Sua senha não pode conter apenas espaços em branco"
    },
    "sign_in_verify_email_title": {
      "en": "We sent you an email",
      "pt": "Te enviamos um e-mail"
    },
    "sign_in_verify_email_message": {
      "en":
          "You'll soon receive an email with a link to activate your account.",
      "pt": "Você vai receber um e-mail com um link para ativar sua conta."
    },
    "sign_in_verify_email_message_login": {
      "en":
          "Please check your mailbox for an email with a link to activate your account.",
      "pt": "Por favor ative sua conta com o link que enviamos por e-mail."
    },
    "forgot_password_success_title": {
      "en": "We sent you an email",
      "pt": "Te enviamos um e-mail"
    },
    "forgot_password_success_message": {
      "en":
          "You'll soon receive an email with instructions to reset your password.",
      "pt":
          "Você vai receber um e-mail com instruções para recuperar sua senha."
    },
    "common_ok": {"en": "OK", "pt": "OK"},
    "validation_message_required": {
      "en": "Please fill in this field",
      "pt": "Por favor preencha este campo"
    },
    "whatsapp_message_interested": {
      "en":
          "Hello! I'm interested in the '$formatItem' that you listed on Alguém Quer? :)",
      "pt":
          "Olá! Me interessei pelo seu anúncio '$formatItem' no Alguém Quer? :)"
    },
    "whatsapp_message_i_want_to_help": {
      "en":
          "Hello! I saw your '$formatItem' request on Alguém Quer? And i'd like to help.",
      "pt":
          "Olá! Vi seu pedido '$formatItem' no Alguém Quer? E eu quero ajudar."
    },
    ''
        "settings_title": {
      ''
          "en": "Settings",
      "pt": "Configurações"
    },
    "profile_and_account_title": {
      "en": "Profile and account",
      "pt": "Perfil e conta"
    },
    "settings_section_account": {"en": "Account", "pt": "Conta"},
    "settings_section_account_close_account": {
      "en": "Close my account",
      "pt": "Encerrar minha conta"
    },
    "settings_section_profile": {"en": "Profile", "pt": "Perfil"},
    "settings_phone_number": {"en": "Phone number", "pt": "Telefone"},
    "settings_phone_number_edit_text_hint": {
      "en": "61 912345678",
      "pt": "61 912345678"
    },
    "settings_phone_number_empty_state": {
      "en": "Tap to add a mobile phone number",
      "pt": "Toque para adicionar o número do seu telefone"
    },
    "settings_name": {"en": "Name", "pt": "Nome"},
    "settings_name_empty_state": {
      "en": "What's your name?",
      "pt": "Como você se chama?"
    },
    "settings_bio": {"en": "Bio", "pt": "Bio"},
    "settings_bio_empty_state": {
      "en": "Add a few words about yourself",
      "pt": "Fale um pouco sobre você"
    },
    "settings_logout": {"en": "Log out", "pt": "Sair"},
    "settings_edit_bio_hint": {
      "en": "You can add a few lines about yourself to your public profile.",
      "pt":
          "Você pode adicionar algumas linhas sobre você ao seu perfil público."
    },
    "settings_edit_name_hint": {
      "en": "What's your name?",
      "pt": "Como você se chama?"
    },
    "settings_edit_phone_number_hint": {
      "en":
          "People interested in your donations will use WhatsApp to get in touch with you.\n\nWe need to send you a verification code to verify your number.",
      "pt":
          "Pessoas interessadas nos seus anúncios vão usar o WhatsApp para entrar em contato contigo.\n\nVamos confirmar seu número, te enviando um código de verificação."
    },
    "settings_donation_request_edit_phone_number_hint": {
      "en":
          "People interested in your donations will use WhatsApp to get in touch with you.\n\nWe need to send you a verification code to verify your number.",
      "pt":
          "Se alguém vir seu pedido e quiser entrar em contato contigo vão usar o WhatsApp.\n\nVamos confirmar seu número, te enviando um código de verificação."
    },
    "settings_edit_phone_number_input_number_title": {
      "en": "Confirm your phone number",
      "pt": "Confirme seu número de telefone"
    },
    "settings_edit_phone_number_input_code_title": {
      "en": "Enter 6-digit code",
      "pt": "Insira o código de 6 dígitos"
    },
    "settings_edit_phone_number_input_code_message": {
      "en": "We've sent a code to $formatItem. Enter the code in that message.",
      "pt":
          "Enviamos o código para $formatItem. O SMS pode levar alguns segundos para chegar."
    },
    "settings_edit_phone_number_input_code_message_auto_retrieval_failed": {
      "en":
          "We were unable to automatically detect the SMS that we sent to $formatItem. If you got the SMS, enter the code.",
      "pt":
          "Não conseguimos detectar automaticmanete o SMS que enviamos para $formatItem.\n\nSe você recebeu o SMS, insira o código."
    },
    "settings_edit_phone_number_code_not_sent_quota_dialog_message": {
      "en": "Hi! I'm editing my phone number and I got this error: ",
      "pt":
          "Olá! Eu estou editando meu número de telefone e recebi esta messagem de erro: "
    },
    "settings_edit_phone_number_code_not_sent_quota_dialog_content": {
      "en":
          "We have blocked all requests from this device due to unusual activity.\n\nTry again later.",
      "pt":
          "Bloqueamos o envio de SMS para esse número devido a atividade incomum.\n\nTente novamente mais tarde."
    },
    "settings_edit_phone_number_verification_failed_invalid_code_dialog_title":
        {"en": "Oops!", "pt": "Código incorreto"},
    "settings_edit_phone_number_verification_failed_invalid_code_dialog_content":
        {
      "en": "It looks like you entered the wrong code. Please try again.",
      "pt":
          "Parece que você digitou o código errado. Tente novamente por favor."
    },
    "settings_edit_phone_number_auto_retrieval_screen_title": {
      "en": "Wait for it...",
      "pt": "Aguarde a verificação automática"
    },
    "settings_edit_phone_number_auto_retrieval_screen_message": {
      "en":
          "We've sent a code to $formatItem. Please wait a few seconds while we attempt to automatically verify the receival.",
      "pt":
          "Enviamos um código para $formatItem. Aguarde alguns segundos enquanto fazemos a verificação automática do recebimento."
    },
    "settings_edit_phone_number_auto_retrieval_screen_i_want_to_type_code_button":
        {
      "en": "I got the code. Let me type it in.",
      "pt": "Recebi o código. Quero digitá-lo."
    },
    "settings_edit_phone_number_input_code_screen_resend_code_button": {
      "en": "Resend code",
      "pt": "Reenviar código"
    },
    "settings_edit_phone_number_resending_code_screen_title": {
      "en": "Resending code...",
      "pt": "Reenviando código..."
    },
    "settings_edit_phone_number_validating_code_screen_title": {
      "en": "Validating code...",
      "pt": "Validando código..."
    },
    "settings_edit_phone_number_validation_complete_screen_title": {
      "en": "Thank you!",
      "pt": "Obrigado!"
    },
    "settings_edit_phone_number_validation_complete_screen_message": {
      "en": "Your phone number has been verified and updated!",
      "pt": "Seu número de telefone foi verificado e atualizado com sucesso!"
    },
    "settings_edit_phone_number_shared_change_number_button": {
      "en": "Change my number",
      "pt": "Mudar o número"
    },
    "settings_edit_phone_number_test_button": {"en": "Test", "pt": "Testar"},
    "settings_edit_phone_number_test_message": {
      "en":
          "If WhatsApp opened a chat with yourself, that means that the number is correct! Now you can go back to the app to save it.",
      "pt":
          "Se o WhatsApp abriu um chat com você mesmo (hehe), significa que o número está certo! Volte para o aplicativo para salvá-lo."
    },
    "settings_edit_phone_verify_button": {
      "en": "Send verification code",
      "pt": "Enviar código de verificação"
    },
    "shared_action_save": {"en": "Save", "pt": "Salvar"},
    "logout_confirmation_title": {"en": "Log out?", "pt": "Sair?"},
    "logout_confirmation_accept_button": {"en": "Log out", "pt": "Sair"},
    "shared_action_cancel": {"en": "Cancel", "pt": "Cancelar"},
    "new_listing_title": {"en": "New listing", "pt": "Novo anúncio"},
    "new_request_listing_title": {"en": "New request", "pt": "Novo pedido"},
    "edit_listing_title": {"en": "Edit listing", "pt": "Editar anúncio"},
    "new_listing_edit_groups_empty_state": {
      "en": "You aren't a member of any groups.",
      "pt": "Você não faz parte de nenhum grupo."
    },
    "new_listing_section_title_photos": {
      "en": "Beautiful photos of the item being donated",
      "pt": "Fotos maneiras do item sendo doado"
    },
    "new_donation_request_listing_section_title_photos": {
      "en": "Images",
      "pt": "Imagens"
    },
    "new_listing_section_title_about": {
      "en": "About the donations",
      "pt": "Sobre a doação"
    },
    "new_donation_request_listing_section_title_about": {
      "en": "What are you in need of?",
      "pt": "De que você está precisando?"
    },
    "new_listing_section_title_for_who": {
      "en": "Who is this donation for",
      "pt": "Quem poderá ver este anúncio?"
    },
    "new_listing_for_who_everyone": {"en": "Anyone", "pt": "Todo mundo"},
    "new_listing_for_who_only_groups": {
      "en": "Just my groups",
      "pt": "Somente meus grupos"
    },
    "new_listing_for_who_only_one_group": {
      "en": "Just this group:",
      "pt": "Somente este grupo:"
    },
    "new_listing_for_who_only_these_groups": {
      "en": "Just these groups:",
      "pt": "Somente estes grupos:"
    },
    "new_listing_action_create": {
      "en": "Create listing",
      "pt": "Criar anúncio"
    },
    "new_donation_request_listing_action_create": {
      "en": "Create request",
      "pt": "Criar pedido"
    },
    "edit_listing_action_save": {"en": "Save", "pt": "Salvar"},
    "new_listing_tile_name": {"en": "Title", "pt": "Título"},
    "new_listing_tile_name_empty_state": {
      "en": "Tap to give your listing a title",
      "pt": "Toque para adicionar o título do anúncio"
    },
    "new_donation_request_listing_tile_name_empty_state": {
      "en": "Tap to give your request a title",
      "pt": "Toque para adicionar um título ao seu pedido"
    },
    "new_listing_tile_description": {"en": "Description", "pt": "Descrição"},
    "new_listing_tile_description_empty_state": {
      "en": "Describe what you are giving away",
      "pt": "Fale um pouco sobre o que você está doando"
    },
    "new_donation_request_listing_tile_description_empty_state": {
      "en": "Describe what you are asking for",
      "pt": "Fale um pouco sobre o que você está pedindo"
    },
    "new_listing_tile_category": {"en": "Category", "pt": "Categoria"},
    "new_listing_tile_category_empty_state": {
      "en": "Choose up to 3 categories ;)",
      "pt": "Você pode escolher até 3 categorias ;)"
    },
    "new_listing_tile_group": {"en": "Private groups", "pt": "Grupos privados"},
    "new_listing_tile_group_empty_state": {
      "en": "Tap here if this donation is only for members of your groups",
      "pt": "Toque aqui se esta doação for apenas para membros dos seus grupos"
    },
    "new_listing_tile_location": {"en": "Location", "pt": "Localização"},
    "new_listing_tile_location_empty_state": {
      "en": "Where can this donation be picked up?",
      "pt": "Onde esta doação pode ser retirada?"
    },
    "new_donation_request_listing_tile_location_empty_state": {
      "en": "Select your city",
      "pt": "Informe sua cidade"
    },
    "new_listing_tile_phone_number_empty_state": {
      "en": "Add a mobile phone number",
      "pt": "Adicione um telefone de contato"
    },
    "new_listing_images_hint": {
      "en": "Don't forget to add some photos :)",
      "pt": "Inclua pelo menos uma imagem"
    },
    "new_listing_edit_title_hint": {
      "en": "Give your listing a title",
      "pt": "Dê um título para seu anúncio"
    },
    "new_donation_request_listing_edit_title_hint": {
      "en": "Give your listing a title",
      "pt": "Dê um título para seu pedido"
    },
    "new_listing_edit_description_hint": {
      "en":
          "Add a few lines about the level of wear and tear of the donation and anything else you find relevant :)",
      "pt":
          "Fale um pouco sobre o estado de conservação da doação e qualquer outra coisa que achar relevante :)"
    },
    "new_donation_request_listing_edit_description_hint": {
      "en":
          "Use this space to add a few lines about what you need and anything else you find relevant :)",
      "pt": "Você pode usar este espaço para falar mais sobre sua necessidade."
    },
    "new_listing_edit_groups_screen_title": {
      "en": "Select groups",
      "pt": "Selecionar grupos"
    },
    "new_listing_all_my_groups": {
      "en": "All of my groups",
      "pt": "Todos meus grupos"
    },
    "page_title_categories": {"en": "Categories", "pt": "Categorias"},
    "edit_categories_title": {
      "en": "Edit categories",
      "pt": "Editar categorias"
    },
    "edit_categories_add_text": {
      "en": "Add a category",
      "pt": "Adicione uma categoria"
    },
    "edit_categories_add_limit_warning": {
      "en": "You can choose up to 3 categories",
      "pt": "Você pode escolher até 3 categorias"
    },
    "image_picker_modal_title": {"en": "Add a new image", "pt": "Nova imagem"},
    "image_picker_modal_camera": {"en": "Camera", "pt": "Câmera"},
    "image_picker_modal_gallery": {"en": "Gallery", "pt": "Galeria"},
    "image_picker_modal_remove": {"en": "Remove image", "pt": "Remover foto"},
    "new_listing_uploading": {
      "en": "Creating listing...",
      "pt": "Criando anúncio..."
    },
    "new_donation_request_listing_uploading": {
      "en": "Creating request...",
      "pt": "Criando pedido..."
    },
    "edit_listing_uploading": {"en": "Saving...", "pt": "Salvando..."},
    "new_listing_cancel_confirmation_title": {
      "en": "Cancel?",
      "pt": "Cancelar?"
    },
    "new_listing_cancel_confirmation_message": {
      "en": "Your progress will not be saved. Are you sure you want to cancel?",
      "pt": "Seu progresso não será salvo. Quer mesmo cancelar?"
    },
    "edit_listing_cancel_confirmation_message": {
      "en": "Your changes will not be saved. Are you sure you want to cancel?",
      "pt": "Suas alterações não serão salvas. Quer mesmo cancelar?"
    },
    "common_add": {"en": "Add", "pt": "Adicionar"},
    "common_yes": {"en": "Yes", "pt": "Sim"},
    "common_no": {"en": "No", "pt": "Não"},
    "common_me": {"en": "Me", "pt": "Eu"},
    "me_listings": {"en": "My listings", "pt": "Meus anúncios"},
    "me_groups": {"en": "My groups", "pt": "Meus grupos"},
    "common_help": {"en": "Help", "pt": "Fale conosco"},
    "common_donation_request": {"en": "Request", "pt": "Pedido"},
    "help_message": {
      "en": "Hi! I'm using Alguém Quer? and I need some help :)",
      "pt": "Oi! Eu estou usando o Alguém Quer? e eu queria uma ajuda :)"
    },
    "my_listings_select_items": {
      "en": "Select listings",
      "pt": "Selecionar anúncios"
    },
    "my_listings_empty_state": {
      "en": "You haven't made any donations yet.",
      "pt": "Você ainda não criou nenhum anúncio."
    },
    "my_listings_empty_state_is_selecting": {
      "en": "You don't have any new donations to add.",
      "pt": "Você não tem novos anúncios para adicionar."
    },
    "my_listings_empty_state_button": {
      "en": "Give something now",
      "pt": "Crie um anúncio agora"
    },
    "common_remove": {"en": "Delete", "pt": "Remover"},
    "common_edit": {"en": "Edit", "pt": "Editar"},
    "common_delete": {"en": "Delete", "pt": "Excluir"},
    "edit_listing_is_active_hint": {
      "en": "This listing will be visible to other users",
      "pt": "Este anúncio estará visível para outros usuários"
    },
    "edit_listing_is_inactive_hint": {
      "en": "This listing will not be visile to other users",
      "pt": "Este anúncio não estará visível para outros usuários"
    },
    "edit_listing_is_active": {"en": "Active", "pt": "Ativo"},
    "edit_listing_is_inactive": {"en": "Inactive", "pt": "Inativo"},
    "log_in_forgot_password": {
      "en": "Forgot your password?",
      "pt": "Esqueceu sua senha?"
    },
    "log_in_didnt_get_verification_email": {
      "en": "Did not receive the activation email?",
      "pt": "Não recebeu o e-mail para ativar sua conta?"
    },
    "log_in_forgot_password_instructions": {
      "en":
          "Enter your email address and we'll send you instructions to reset your password.",
      "pt":
          "Informe o e-mail usado para acessar sua conta e te enviaremos instruções para alterar sua senha."
    },
    "log_in_didnt_get_verification_email_instructions": {
      "en":
          "Enter your email address and we'll resend you the link to activate your account.",
      "pt":
          "Informe o e-mail usado para acessar sua conta e te enviaremos um link para ativar sua conta."
    },
    "log_in_error_bad_credentials_title": {"en": "Oops", "pt": "Ops"},
    "log_in_error_bad_credentials_message": {
      "en": "Wrong email or password.",
      "pt": "Verifique seu e-mail e senha e tente novamente."
    },
    "log_in_error_not_activated_title": {
      "en": "Almost there...",
      "pt": "Quase lá..."
    },
    "log_in_error_not_activated_message": {
      "en":
          "Please check your mailbox for an email with a link to activate your account.",
      "pt": "Por favor ative sua conta com o link que enviamos por e-mail."
    },
    "resend_activation_error_already_activated_title": {
      "en": "So...",
      "pt": "Opa!"
    },
    "resend_activation_error_already_activated_message": {
      "en":
          "This account has already been activated. You can login with your email and password.",
      "pt":
          "Esta conta já foi ativada. Você pode fazer login com seu e-mail e senha."
    },
    "login_assistance_email_not_found_title": {"en": "Oh, my!", "pt": "Eita!"},
    "login_assistance_email_not_found_message": {
      "en": "We couldn't find any users with that email address.",
      "pt": "Não encontramos nenhum usuário com esse e-mail."
    },
    "common_send": {"en": "Send", "pt": "Enviar"},
    "log_in_help_me": {
      "en": "Need help logging in?",
      "pt": "Precisa de ajuda para acessar sua conta?"
    },
    "log_in_help_me_chat_message": {
      "en": "Hello! I need help logging in to Alguém Quer?.",
      "pt": "Olá! Preciso de ajuda para acessar minha conta do Alguém Quer?."
    },
    "sign_up_help_me": {
      "en": "Need help creating your account?",
      "pt": "Precisa de ajuda para criar sua conta?"
    },
    "sign_up_help_me_chat_message": {
      "en": "Hello! I need help creating my Alguém Quer? account.",
      "pt": "Olá! Preciso de ajuda para criar minha conta no Alguém Quer?."
    },
    "sign_up_error_409_title": {"en": "Oh, my!", "pt": "Eita!"},
    "sign_up_error_409_messge": {
      "en": "That email address is already taken.",
      "pt": "Já existe um usuário com esse e-mail."
    },
    "sign_up_error_409_recover_email_button": {
      "en": "Recover password",
      "pt": "Recuperar senha"
    },
    "error_generic_title": {
      "en": "Something went wrong",
      "pt": "Houve um problema"
    },
    "error_generic_message": {
      "en": "Please check your internet connection and try again.",
      "pt": "Por favor verifique se tem conexão à internet e tente novamente."
    },
    "error_generic_report_message": {
      "en": "Hi! I was using Alguém Quer? and something went wrong when ...",
      "pt": "Oi! Eu estava usando o Alguém Quer? e deu ruim quando ..."
    },
    "action_report": {"en": "Report", "pt": "Reportar"},
    "profile_image_picker_modal_title": {
      "en": "Profile picture",
      "pt": "Foto de perfil"
    },
    "profile_cancel_upload_confirmation_title": {
      "en": "Cancel upload?",
      "pt": "Cancelar upload?"
    },
    "profile_cancel_upload_confirmation_message": {
      "en":
          "Your new picture is still being uploaded. Are you sure you want to cancel?",
      "pt": "A nova foto ainda não foi salva. Quer mesmo cancelar?"
    },
    "sub_categories_parent_category_prefix": {"en": "All", "pt": "Tudo de"},
    "categories_everything_list_item_title": {
      "en": "Everything, everything",
      "pt": "Tudo"
    },
    "categories_all_donations_list_item_title": {
      "en": "Everything, everything",
      "pt": "Todas as doações"
    },
    "categories_all_donations_requests_list_item_title": {
      "en": "Everything, everything",
      "pt": "Todos os pedidos"
    },
    "categories_type_donations": {"en": "Give aways", "pt": "Doações"},
    "categories_type_donation_requests": {
      "en": "Donation requests",
      "pt": "Pedidos de doação"
    },
    "error_upload_listing_report_message": {
      "en":
          "Hi! I was using Alguém Quer? and something went wrong when I tried to create a listing :/",
      "pt":
          "Oi! Eu estava usando o Alguém Quer? e deu ruim quando tentei criar um anúncio :/"
    },
    "facebook_login_cancelled_message": {
      "en": "Facebook login cancelled.",
      "pt": "Login com facebook cancelado."
    },
    "facebook_login_error_message": {
      "en": "Facebook login failed.",
      "pt": "Login com facebook falhou."
    },
    "published_on_at_": {
      "en": "Published on $formatItem at $formatItem",
      "pt": "Publicado em $formatItem às $formatItem"
    },
    "published_on_": {
      "en": "Published on $formatItem",
      "pt": "Publicado em $formatItem"
    },
    "location_filter_all_countries": {
      "en": "All countries",
      "pt": "Todos os países"
    },
    "location_filter_all_states": {
      "en": "All states",
      "pt": "Todos os estados"
    },
    "location_filter_all_cities": {
      "en": "All cities",
      "pt": "Todas as cidades"
    },
    "location_filter_help_me": {
      "en": "My city isn't on this list",
      "pt": "Não encontrei minha cidade na lista"
    },
    "location_filter_help_me_chat_message": {
      "en": "Hi! My city isn't in the list of cities. I live in ...",
      "pt":
          "Olá! Minha cidade não aparece na lista de cidade no Alguém Quer?. Eu moro em ..."
    },
    "customer_service_dialog_title": {
      "en": "Thanks for reaching out!",
      "pt": "Vamos te ajudar!"
    },
    "customer_service_dialog_content": {
      "en":
          "You will be taken to a WhatsApp chat with someone from our support team.",
      "pt":
          "Você será redirecionado para uma conversa WhatsApp com alguém da equipe de suporte."
    },
    "member_since_": {
      "en": "On Alguém Quer since $formatItem.",
      "pt": "No Alguém Quer desde $formatItem."
    },
    "shared_dont_show_this_again": {
      "en": "Don't show this again",
      "pt": "Não mostrar novamente"
    },
    "terms_acceptance_caption_by_signing_in_": {
      "en": "By signing in, you agree to our  ",
      "pt": "Ao criar ou acessar sua conta, você declara que aceita a "
    },
    "terms_acceptance_caption_by_continuing_": {
      "en": "By continuing, you agree to our  ",
      "pt": "Ao continuar, declaro que aceito a "
    },
    "terms_acceptance_caption_by_contacting_": {
      "en": "By continuing, you agree to our  ",
      "pt": "Ao entrar em contato com o anunciante, declaro que aceito a "
    },
    "terms_acceptance_caption_read_": {"en": "Read our  ", "pt": "Confira a "},
    "terms_acceptance_caption_termos": {
      "en": "Terms of service",
      "pt": "Termos de serviço"
    },
    "terms_acceptance_caption_and_the_": {"en": " and the ", "pt": " e os "},
    "terms_acceptance_caption_privacy": {
      "en": "Privacy policy",
      "pt": "Política de privacidade"
    },
    "i_want_it_dialog_title": {
      "en": "Get in touch with the owner",
      "pt": "Entre em contato com o anunciante"
    },
    "i_want_it_dialog_whatsapp": {"en": "WhatsApp", "pt": "WhatsApp"},
    "i_want_it_dialog_call": {"en": "Call", "pt": "Ligar"},
    "error_network_layer_generic": {
      "en":
          "Something went wrong. Make sure you're connected to the internet and try again.",
      "pt":
          "Houve um erro. Verifique se tem conexão à internet e tente novamente."
    },
    "image_cropper_toolbar_title": {"en": "Edit photo", "pt": "Editar foto"},
    "settings_about": {"en": "About", "pt": "Sobre"},
    "about_version_x": {
      "en": "Version $formatItem",
      "pt": "Versão $formatItem"
    },
    "about_copyright_info": {
      "en": "Copyright information:",
      "pt": "Informações sobre direitos autorais:"
    },
    "about_copyright_info_icons_made_by_": {
      "en": "Icons made by $formatItem",
      "pt": "Ícones feitos por $formatItem"
    },
    "about_copyright_info_icons_from_": {
      "en": "Icons from $formatItem",
      "pt": "Ícones de  $formatItem"
    },
    "about_opensource_we_use": {
      "en": "We use these open source librarie to make Alguém Quer?:",
      "pt": "Usamos estas bibloitecas open source para construir Alguém Quer?:"
    },
    "delete_listing_confirmation_title": {
      "en": "Delete listing?",
      "pt": "Excluir anúncio?"
    },
    "delete_listing_confirmation_content": {
      "en": "Are you sure? After you delete this, it can't be recovered.",
      "pt": "Tem certeza? Anúncios excluídos não podem ser recuperados."
    },
    "delete_listing_loading_state_text": {
      "en": "Deleting...",
      "pt": "Excluindo..."
    },
    "delete_listing_accept_button": {"en": "Delete", "pt": "Excluir"},
    "force_update_title": {
      "en": "We're better than ever",
      "pt": "Estamos melhores que nunca!"
    },
    "force_update_message": {
      "en":
          "A new version of the app is available and this version is no longer supported.",
      "pt":
          "Temos uma nova versão do aplicativo disponível e não suportamos mais esta versão."
    },
    "force_update_button": {
      "en": "Update the app now",
      "pt": "Atualizar o app agora"
    },
    "product_detail_action_hide": {
      "en": "Hide listing",
      "pt": "Ocultar anúncio"
    },
    "product_detail_action_reactivate": {
      "en": "Reactivate listing",
      "pt": "Reativar anúncio"
    },
    "product_detail_action_edit": {
      "en": "Edit listing",
      "pt": "Editar anúncio"
    },
    "product_detail_action_delete": {
      "en": "Delete listing",
      "pt": "Excluir anúncio"
    },
    "product_detail_no_shipping_alert": {
      "en":
          "This item must be collected in person in $formatItem. It won't be sent by mail.",
      "pt":
          "Este item deve ser retirado em $formatItem.\n\nAtenção: Não será enviado pelos correios."
    },
    "product_detail_no_shipping_alert_null_location": {
      "en": "This item must be collected in person. It won't be sent by mail.",
      "pt":
          "Este item deve ser retirado pessoalmente. Não será enviado pelos correios."
    },
    "product_detail_i_want_it_dialog_no_shipping_alert": {
      "en": "This item must be collected in person in $formatItem.",
      "pt":
          "Atenção: Este item deve ser retirado pessoalmente em $formatItem.\n\nNão será enviado pelos correios."
    },
    "product_detail_user_introduction": {
      "en": "Hi! I'm $formatItem.",
      "pt": "Oi! Sou $formatItem."
    },
    "product_detail_user_see_all_donations_part_1": {
      "en": "Tap here",
      "pt": "Toque aqui"
    },
    "product_detail_user_see_all_donations_part_2": {
      "en": " to see all of my donations :)",
      "pt": " se quiser ver todas as minhas doações :)"
    },
    "product_detail_report_listing_title": {"en": "Report", "pt": "Denúncia"},
    "product_detail_report_listing_text": {
      "en": "Is there something awry with this listing? Report it here.",
      "pt": "Encontrou algo de errado com este anúncio? Denuncie-o aqui."
    },
    "product_detail_report_listing_message": {
      "en": "Hi! I'd like to report the listing: '$formatItem...'",
      "pt": "Olá! Quero denunciar o anúncio: '$formatItem...'"
    },
    "product_detail_description_subtitle": {
      "en": "Description",
      "pt": "Descrição"
    },
    "product_detail_different_location_alert_title": {
      "en":
          "This item must be picked up in person in a another. It won't be sent by mail.",
      "pt":
          "Este item deve ser retirado por você em outra cidade. Não temos serviço de envio pelos correios."
    },
    "product_detail_different_location_alert_content": {
      "en": "Do you still want to coninue.",
      "pt": "Você quer continuar mesmo assim?"
    },
    "product_detail_different_location_alert_continue_button": {
      "en": "Yes",
      "pt": "Sim"
    },
    "product_detail_different_location_alert_cancel_button": {
      "en": "No, I want to cancel",
      "pt": "Não, quero cancelar"
    },
    "hide_listing_confirmation_title": {
      "en": "Hide listing?",
      "pt": "Ocultar anúncio?"
    },
    "hide_listing_confirmation_content": {
      "en": "This listing will no longer be visile to other users.",
      "pt":
          "Este anúncio não estará mais visível para outros usuários.\n\nVocê pode reativá-lo quando quiser."
    },
    "hide_listing_accept_button": {
      "en": "Hide listing",
      "pt": "Ocultar anúncio"
    },
    "reactivate_listing_confirmation_title": {
      "en": "Reactivate listing?",
      "pt": "Reativar anúncio?"
    },
    "product_detail_inactive_listing_alert": {
      "en": "This listing is not visible to other users.",
      "pt": "Este anúncio não está visível para outros usuários."
    },
    "reactivate_listing_confirmation_content": {
      "en": "This listing will be visible to other users.",
      "pt": "Este anúncio estará visível para outros usuários."
    },
    "reactivate_listing_accept_button": {
      "en": "Reactivate listing",
      "pt": "Reativar anúncio"
    },
    "shared_title_options": {"en": "Options", "pt": "Opções"},
    "quick_menu_title": {
      "en": "What do you want to do today?",
      "pt": "O que você quer fazer hoje?"
    },
    "quick_menu_option_create_donation": {
      "en": "Give something away",
      "pt": "Doar algo"
    },
    "quick_menu_option_create_request": {
      "en": "Ask for a donation",
      "pt": "Pedir uma doação"
    },
    "quick_menu_option_join_group": {
      "en": "Join a group",
      "pt": "Entrar em um grupo"
    },
    "quick_menu_option_create_listing": {
      "en": "Create a listing",
      "pt": "Criar um anúncio"
    },
    "quick_menu_option_create_group": {
      "en": "Create a group",
      "pt": "Criar um grupo"
    },
    "quick_menu_option_browse_listing": {
      "en": "Browse listings",
      "pt": "Explorar anúncios"
    },
    "quick_menu_option_go_to_my_groups": {
      "en": "Go to my groups",
      "pt": "Acessar meus grupos"
    },
    "join_group_screen_title": {
      "en": "Join a group",
      "pt": "Entrar em um grupo"
    },
    "join_group_screen_input_prompt": {
      "en": "Enter the group's code.",
      "pt": "Digite o código do grupo"
    },
    "join_group_screen_group_not_found_title": {
      "en": "Group not found",
      "pt": "Grupo não encontrado"
    },
    "join_group_screen_group_not_found_text": {
      "en": "We couldn't find groups for that code.",
      "pt": "Não encontramos nenhum grupo que corresponda a esse código."
    },
    "join_group_screen_group_already_a_member_title": {
      "en": "You are already a member of this group",
      "pt": "Você já é membro deste grupo"
    },
    "join_group_screen_group_already_a_member_text": {
      "en": "Go to 'My Groups' to see a list of your groups.",
      "pt": "Acesse 'Meus Grupos' para ver a lista dos seus grupos."
    },
    "join_group_screen_group_what_code_is_this_title": {
      "en": "What code is this?",
      "pt": "Que código é esse?"
    },
    "join_group_screen_group_what_code_is_this_text": {
      "en":
          "Groups are private giving groups e their access codes are secrets. If you were invited to a group, the group owner needs to give you the access code.",
      "pt":
          "A participação em grupos privados de desapego é apenas por convite. Se você foi convidado para um grupo, algum membro do grupo precisa te dar o código de acesso."
    },
    "shared_try_again": {"en": "Try again", "pt": "Tente novamente"},
    "create_group_screen_title": {
      "en": "Create a group",
      "pt": "Criar um grupo"
    },
    "create_group_form_name_label": {
      "en": "Give your group a name",
      "pt": "Dê um nome para seu grupo"
    },
    "create_group_form_submit_button_text": {
      "en": "Create group",
      "pt": "Criar grupo"
    },
    "my_groups_screen_title": {"en": "My groups", "pt": "Meus grupos"},
    "my_groups_create_group_cta": {
      "en": "Create a new group",
      "pt": "Criar um novo grupo"
    },
    "my_groups_join_group_cta": {
      "en": "Join a group",
      "pt": "Entrar em um grupo"
    },
    "leave_group_confirmation_title": {
      "en": "Leave group?",
      "pt": "Sair do grupo?"
    },
    "leave_group_confirmation_content": {
      "en": "You'll need to use the access code to join again.",
      "pt":
          "Você vai precisar usar o código de acesso se quiser ingressar de novo."
    },
    "leave_group_confirmation_button_text": {
      "en": "Leave group",
      "pt": "Sair do grupo"
    },
    "edit_group_screen_title": {"en": "Edit group", "pt": "Editar grupo"},
    "edit_group_screen_add_image_moda_title": {
      "en": "Group image",
      "pt": "Imagem do grupo"
    },
    "edit_group_information_subtitle": {
      "en": "Group information",
      "pt": "Informações do grupo"
    },
    "edit_group_information_description_empty_state": {
      "en": "This group has no description.",
      "pt": "Nenhuma descrição para este grupo."
    },
    "edit_group_name_tile_caption": {"en": "Group name", "pt": "Nome do grupo"},
    "edit_group_name_tile_empty_state_caption": {
      "en": "Tap to edit",
      "pt": "Toque para editar"
    },
    "edit_group_description_tile_caption": {
      "en": "Group description",
      "pt": "Descrição do grupo"
    },
    "edit_group_description_tile_empty_state_caption": {
      "en": "Tap to add a description",
      "pt": "Toque para adicionar uma descrição"
    },
    "group_detail_screen_description_empty_state": {
      "en": "Nothing in this group yet. 🤷🏽",
      "pt": "Nenhum anúncio neste grupo ainda. 🤷🏽"
    },
    "group_detail_screen_create_new_listing": {
      "en": "Create a new listing",
      "pt": "Criar um anúncio novo"
    },
    "group_detail_screen_add_my_listings": {
      "en": "Add some of my listings",
      "pt": "Adicionar alguns dos meus anúncios"
    },
    "group_information_screen_acess_code": {
      "en": "Access code",
      "pt": "Código de acesso"
    },
    "group_information_screen_description": {
      "en": "Description",
      "pt": "Descrição"
    },
    "group_information_screen_members": {"en": "Members", "pt": "Membros"},
    "group_information_member_tile_admin_label": {
      "en": "Group admin",
      "pt": "Admin do grupo"
    },
    "share_group_text": {
      "en":
          "Hi! I'd like to invite you to our giving group! 😃\n\nGo to \"$formatItem\" to download the app.\n\nOut group's access code is $formatItem. 😉",
      "pt":
          "Oi! Quero te convidar para o grupo de doações e trocas \"$formatItem\" que criamos no app Alguém Quer! 😃\n\nBaixe o app em $formatItem.\n\nO código para entrar no nosso grupo é $formatItem. 😉"
    },
    "progressive_onboarding_ok_button": {"en": "I got it!", "pt": "OK"},
    "progressive_onboarding_create_group_text": {
      "en": "Groups are private and only group members can see the listings.",
      "pt":
          "Que tal criar um grupo de desapego com as pessoas do seu condomínio, da sua escola ou da turma do trabalho?\n\nSomente os membros do grupo podem ver os anúncios."
    },
    "progressive_onboarding_create_group_button_text": {
      "en": "Create a group",
      "pt": "Criar um grupo"
    },
    "progressive_onboarding_join_group_text": {
      "en": "Groups are private and only group members can see the listings.",
      "pt":
          "A participação em grupos privados de desapego é apenas por convite. Você precisa de um código de acesso para ingressar."
    },
    "progressive_onboarding_join_group_button_text": {
      "en": "Join a group",
      "pt": "Entrar em um grupo"
    },
    "progressive_onboarding_donation_text": {
      "en": "Groups are private and only group members can see the listings.",
      "pt":
          "Abra espaço para o novo! Doe livros, roupas e outros itens que estão em ótimo estado."
    },
    "progressive_onboarding_donation_button_text": {
      "en": "Create a listing",
      "pt": "Criar um anúncio"
    },
    "progressive_onboarding_donation_request_group_text": {
      "en": "Groups are private and only group members can see the listings.",
      "pt":
          "Está precisando de algo? Crie um pedido de doação. Talvez alguém da sua cidade possa ajudar."
    },
    "progressive_onboarding_donation_request_group_button_text": {
      "en": "Ask for something",
      "pt": "Criar um pedido"
    },
    "close_account_confirmation_string": {"en": "DELETE", "pt": "ENCERRAR"},
    "delete_me_confirmation_text": {
      "en": "Type the word \"$formatItem\" to confirm.",
      "pt": "Digite a palavra \"$formatItem\" no campo abaixo para confirmar."
    },
    "delete_me_confirmation_button": {
      "en": "Delete my account",
      "pt": "Encerrar minha conta"
    },
    "delete_me_cancel_button": {"en": "Nevermind", "pt": "Deixa pra lá"},
    "create_cancellation_intent_paragraph_1": {
      "en":
          "This will delete all of you data and your account. All of your listings will be deleted. If you created any groups, admin privileges will be transered to the oldest member of the group.",
      "pt":
          "Esta ação irá apagar permanentemente todos seus dados e a sua conta. Todos seus anúncios serão apagados. Se você criou algum grupo, os privilégios de admin serão transferidos para o membro mais antigo do grupo."
    },
    "create_cancellation_intent_paragraph_2": {
      "en": "This action cannot be undone.",
      "pt": "Esta ação é irreversível."
    },
    "create_cancellation_intent_paragraph_3": {
      "en": "Are you sure you want to delete your account?",
      "pt": "Você quer encerrar definitivamente sua conta?"
    },
    "create_cancellation_intent_confirmation_button": {
      "en": "Yes, I want to delete my account",
      "pt": "Sim, quero encerrar minha conta"
    },
    "create_cancellation_intent_cancel_button": {
      "en": "Nevermind",
      "pt": "Deixa pra lá"
    },
  };
}
