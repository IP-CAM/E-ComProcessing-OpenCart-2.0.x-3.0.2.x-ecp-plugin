<?php
/*
 * Copyright (C) 2018 E-Comprocessing Ltd.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * @author      E-Comprocessing
 * @copyright   2018 E-Comprocessing Ltd.
 * @license     http://opensource.org/licenses/gpl-2.0.php GNU General Public License, version 2 (GPL-2.0)
 */
?>

<style>
    @media(max-width:992px) {
        .form-container {
            float: none !important;
            margin: 0 auto !important;
        }

        .form-container input {
            margin: 16px 0;
        }
    }
    @media(min-width:992px) {
        .card-wrapper {
            float: right;
            margin-top: 8px;
        }

        .form-container {
            float: left;
        }

        .form-container input {
            margin: 16px;
        }
    }

    .form-container {
        width:350px;
    }
</style>

<?php foreach ($scripts as $script) { ?>
    <script src="<?php echo $script; ?>" type="text/javascript"></script>
<?php } ?>

<form class="form-horizontal ecomprocessing-direct">
    <fieldset id="payment">
        <legend>
            <?php echo $text_credit_card; ?>
        </legend>
        <div class="cc-container">
            <div class="alert alert-warning alert-checkout" hidden="hidden">
                <i class="fa fa-exclamation-circle"></i>
                <span class="alert-text"></span>
                <button type="button" class="close" data-hide="alert-checkout">&times;</button>
            </div>

            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="card-wrapper"></div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="form-container form-group active">
                        <input placeholder="<?php echo $entry_cc_number;?>" class="form-control" type="text" name="ecomprocessing_direct-cc-number">
                        <input placeholder="<?php echo $entry_cc_owner;?>" class="form-control" type="text" name="ecomprocessing_direct-cc-holder">
                        <input placeholder="<?php echo $entry_cc_expiry;?>" class="form-control" type="text" name="ecomprocessing_direct-cc-expiration">
                        <input placeholder="<?php echo $entry_cc_cvv;?>" class="form-control" type="text" name="ecomprocessing_direct-cc-cvv">
                    </div>
                </div>
            </div>
        </div>
    </fieldset>
</form>

<div class="buttons">
    <div class="pull-right">
        <input type="button" value="<?php echo $button_confirm; ?>" id="button-confirm" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-primary" />
    </div>
</div>

<script type="text/javascript">
    new Card({
        form: '.ecomprocessing-direct',
        container: '.card-wrapper',
        messages: {
            legalText: '<?php echo $text_card_legal;?>'
        },
        formSelectors: {
            numberInput     : 'input[name="ecomprocessing_direct-cc-number"]',
            nameInput       : 'input[name="ecomprocessing_direct-cc-holder"]',
            expiryInput     : 'input[name="ecomprocessing_direct-cc-expiration"]',
            cvcInput        : 'input[name="ecomprocessing_direct-cc-cvv"]'
        }
    });

    $(function(){
        $("[data-hide]").on("click", function(){
            $(this).closest("." + $(this).attr("data-hide")).fadeOut();
        });
    });

    $(document).ready(function() {
        $('#button-confirm').bind('click', function () {
            $.ajax({
                url: '<?php echo $button_target;?>',
                type: 'post',
                data: $('.ecomprocessing-direct').serialize(),
                cache: false,
                dataType: 'json',
                beforeSend: function () {
                    $('#button-confirm').button('loading').prop('disabled', true);
                },
                success: function (json) {
                    if (json['error']) {
                        $('.alert-checkout .alert-text').text(json['error']);

                        $('.alert-checkout').fadeIn();

                        $('#button-confirm').button('reset').prop('disabled', false);
                    }

                    if (json['redirect']) {
                        location = json['redirect'];
                    }
                }
            });
        });
    });
</script>
