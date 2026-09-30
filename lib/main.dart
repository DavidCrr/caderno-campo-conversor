import 'package:flutter/material.dart';

void main() {
  runApp(const ConversorRocaApp());
}

/// App principal com configuração de tema voltado para o campo
class ConversorRocaApp extends StatelessWidget {
  const ConversorRocaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor da Roça - Vale de São Patrício',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E5631), // Verde agrícola de alto contraste
          primary: const Color(0xFF1E5631),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const TelaConversor(),
    );
  }
}

/// Tela principal do Conversor de Unidades
class TelaConversor extends StatefulWidget {
  const TelaConversor({super.key});

  @override
  State<TelaConversor> createState() => _TelaConversorState();
}

class _TelaConversorState extends State<TelaConversor> {
  // Controlador para o campo de texto
  final TextEditingController _valorController = TextEditingController();

  // Tipo de grandeza: 'area' ou 'peso'
  String _tipoGrandeza = 'area';

  // Unidades selecionadas
  String _unidadeOrigem = 'ha';
  String _unidadeDestino = 'alq_go';

  // Estado do cálculo e da validação
  double? _resultado;
  String? _mensagemErro;
  String _detalhesFormula = '';

  // Definição das unidades regionais (Vale de São Patrício)
  final Map<String, String> _nomesUnidades = {
    // Área
    'ha': 'Hectares (ha)',
    'alq_go': 'Alqueires Goianos (4,84 ha)',
    'm2': 'Metros Quadrados (m²)',
    // Peso / Safra
    'sc': 'Sacas de 60 kg (sc)',
    'arroba': 'Arrobas (@ - 15 kg)',
    'kg': 'Quilos (kg)',
    'ton': 'Toneladas (t)',
  };

  final List<String> _unidadesArea = ['ha', 'alq_go', 'm2'];
  final List<String> _unidadesPeso = ['sc', 'arroba', 'kg', 'ton'];

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  /// Troca entre as abas de Área e Peso/Safra
  void _mudarTipoGrandeza(String novoTipo) {
    setState(() {
      _tipoGrandeza = novoTipo;
      if (novoTipo == 'area') {
        _unidadeOrigem = 'ha';
        _unidadeDestino = 'alq_go';
      } else {
        _unidadeOrigem = 'sc';
        _unidadeDestino = 'arroba';
      }
      _executarConversao(_valorController.text);
    });
  }

  /// Inverte as unidades de origem e destino rapidamente
  void _inverterUnidades() {
    setState(() {
      final temp = _unidadeOrigem;
      _unidadeOrigem = _unidadeDestino;
      _unidadeDestino = temp;
      _executarConversao(_valorController.text);
    });
  }

  /// Lógica de Conversão e Validação em tempo real (onChanged)
  void _executarConversao(String textoEntrada) {
    setState(() {
      final textoLimpo = textoEntrada.trim().replaceAll(',', '.');

      if (textoLimpo.isEmpty) {
        _resultado = null;
        _mensagemErro = null;
        _detalhesFormula = '';
        return;
      }

      final valor = double.tryParse(textoLimpo);

      // Validação 1: Entrada não numérica
      if (valor == null) {
        _resultado = null;
        _mensagemErro = 'Digite um número válido (ex: 10 ou 4,84).';
        _detalhesFormula = '';
        return;
      }

      // Validação 2: Valores negativos ou zero
      if (valor <= 0) {
        _resultado = null;
        _mensagemErro = 'O valor informado deve ser maior que zero.';
        _detalhesFormula = '';
        return;
      }

      // Se passou nas validações, calcula
      _mensagemErro = null;
      if (_tipoGrandeza == 'area') {
        _resultado = _converterArea(valor, _unidadeOrigem, _unidadeDestino);
      } else {
        _resultado = _converterPeso(valor, _unidadeOrigem, _unidadeDestino);
      }
    });
  }

  /// Fatores de conversão de Área em relação ao Hectare (ha)
  /// 1 alqueire goiano = 4.84 ha = 48.400 m²
  double _converterArea(double valor, String de, String para) {
    double emHectares;
    switch (de) {
      case 'alq_go':
        emHectares = valor * 4.84;
        break;
      case 'm2':
        emHectares = valor / 10000.0;
        break;
      case 'ha':
      default:
        emHectares = valor;
        break;
    }

    double finalValue;
    switch (para) {
      case 'alq_go':
        finalValue = emHectares / 4.84;
        _detalhesFormula = '1 Alqueire Goiano = 4,84 ha (48.400 m²)';
        break;
      case 'm2':
        finalValue = emHectares * 10000.0;
        _detalhesFormula = '1 Hectare = 10.000 m²';
        break;
      case 'ha':
      default:
        finalValue = emHectares;
        _detalhesFormula = 'Mesma unidade selecionada';
        break;
    }
    return finalValue;
  }

  /// Fatores de conversão de Safra/Peso em relação a Quilos (kg)
  /// 1 saca = 60 kg | 1 arroba = 15 kg (4 arrobas por saca) | 1 ton = 1000 kg
  double _converterPeso(double valor, String de, String para) {
    double emKg;
    switch (de) {
      case 'sc':
        emKg = valor * 60.0;
        break;
      case 'arroba':
        emKg = valor * 15.0;
        break;
      case 'ton':
        emKg = valor * 1000.0;
        break;
      case 'kg':
      default:
        emKg = valor;
        break;
    }

    double finalValue;
    switch (para) {
      case 'sc':
        finalValue = emKg / 60.0;
        _detalhesFormula = '1 Saca de Soja/Milho = 60 kg (4 Arrobas)';
        break;
      case 'arroba':
        finalValue = emKg / 15.0;
        _detalhesFormula = '1 Arroba (@) = 15 kg (1 saca = 4 @)';
        break;
      case 'ton':
        finalValue = emKg / 1000.0;
        _detalhesFormula = '1 Tonelada = 1.000 kg (~16,66 sacas)';
        break;
      case 'kg':
      default:
        finalValue = emKg;
        _detalhesFormula = 'Mesma unidade selecionada';
        break;
    }
    return finalValue;
  }

  /// Formatação brasileira (troca ponto por vírgula e limita casas decimais)
  String _formatarNumero(double valor) {
    if (valor >= 1000) {
      return valor.toStringAsFixed(2).replaceAll('.', ',');
    } else if (valor % 1 == 0) {
      return valor.toInt().toString();
    } else {
      return valor.toStringAsFixed(3).replaceAll('.', ',');
    }
  }

  @override
  Widget build(BuildContext context) {
    final listaUnidades =
        _tipoGrandeza == 'area' ? _unidadesArea : _unidadesPeso;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversor da Roça',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF1E5631),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Contexto regional
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.agriculture, color: Color(0xFF1E5631), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Padrão regional: Vale de São Patrício (GO)\nAlqueire Goiano = 4,84 ha | Saca = 60 kg',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1E5631),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seletor de Categoria (Área x Safra/Peso)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48, // Alvo de toque adequado
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tipoGrandeza == 'area'
                            ? const Color(0xFF1E5631)
                            : Colors.white,
                        foregroundColor: _tipoGrandeza == 'area'
                            ? Colors.white
                            : const Color(0xFF1E5631),
                        elevation: _tipoGrandeza == 'area' ? 3 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFF1E5631)),
                        ),
                      ),
                      onPressed: () => _mudarTipoGrandeza('area'),
                      icon: const Icon(Icons.crop_landscape),
                      label: const Text(
                        'Área (ha / alq)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tipoGrandeza == 'peso'
                            ? const Color(0xFF1E5631)
                            : Colors.white,
                        foregroundColor: _tipoGrandeza == 'peso'
                            ? Colors.white
                            : const Color(0xFF1E5631),
                        elevation: _tipoGrandeza == 'peso' ? 3 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFF1E5631)),
                        ),
                      ),
                      onPressed: () => _mudarTipoGrandeza('peso'),
                      icon: const Icon(Icons.scale),
                      label: const Text(
                        'Safra (sc / @)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Campo de Entrada com onChanged em tempo real
            const Text(
              'Valor a converter:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _valorController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              onChanged: _executarConversao,
              decoration: InputDecoration(
                hintText: 'Ex: 10 ou 4,84',
                prefixIcon: const Icon(Icons.edit, color: Color(0xFF1E5631)),
                suffixIcon: _valorController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _valorController.clear();
                          _executarConversao('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF1E5631), width: 2),
                ),
                errorText: _mensagemErro,
              ),
            ),
            const SizedBox(height: 20),

            // Seleção de Unidades (Origem e Destino com botão de inverter)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Unidade de Origem
                  _buildDropdownRow(
                    rotulo: 'De (Origem):',
                    valorAtual: _unidadeOrigem,
                    opcoes: listaUnidades,
                    onChanged: (novo) {
                      if (novo != null) {
                        setState(() {
                          _unidadeOrigem = novo;
                          _executarConversao(_valorController.text);
                        });
                      }
                    },
                  ),
                  const Divider(height: 24),
                  // Botão de inversão rápida
                  Center(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E5631),
                        side: const BorderSide(color: Color(0xFF1E5631)),
                        minimumSize: const Size(160, 42),
                      ),
                      onPressed: _inverterUnidades,
                      icon: const Icon(Icons.swap_vert, size: 20),
                      label: const Text('Inverter Unidades'),
                    ),
                  ),
                  const Divider(height: 24),
                  // Unidade de Destino
                  _buildDropdownRow(
                    rotulo: 'Para (Destino):',
                    valorAtual: _unidadeDestino,
                    opcoes: listaUnidades,
                    onChanged: (novo) {
                      if (novo != null) {
                        setState(() {
                          _unidadeDestino = novo;
                          _executarConversao(_valorController.text);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cartão de Resultado com alto contraste para leitura no sol
            if (_resultado != null && _mensagemErro == null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E5631),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'RESULTADO DA CONVERSÃO',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA5D6A7),
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatarNumero(_resultado!),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _nomesUnidades[_unidadeDestino] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_detalhesFormula.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x26FFFFFF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _detalhesFormula,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else if (_valorController.text.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Digite um valor acima para ver o resultado.',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Constrói a linha com Dropdown de seleção de unidades
  Widget _buildDropdownRow({
    required String rotulo,
    required String valorAtual,
    required List<String> opcoes,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48, // Alvo de toque conforme critério de usabilidade
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: valorAtual,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E5631)),
              onChanged: onChanged,
              items: opcoes.map((unidade) {
                return DropdownMenuItem<String>(
                  value: unidade,
                  child: Text(
                    _nomesUnidades[unidade] ?? unidade,
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
